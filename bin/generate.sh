#!/bin/bash

#
#  Script for preparation of input data for weak scaling tests.
#
# set -x


function usage {
    echo "Script for preparation of input data for weak scaling tests."
    echo ""
    echo "Creates mesh with number of elements close to given value 'n_elements_expect'."
    echo "Implements combination of Newton-like and regula falsi method."
    echo "The algorithm is far to be robust since number of elements is not monotone function"
    echo "of the step size and moreover is very sensitive in particular for small meshes."
    echo ""
    echo "Options:"
    echo "  -g|--geo                geometry template, step parameter is modified"
    echo "  -d|--dim                dimension of the mesh"
    echo "  -e|--elems              number of elements for single processor"
    echo "  -i|--init               initial factor for step reduction"
    echo "  --                      all argument after double shash"
    echo "                          are considered sequence for number of processors"
    echo "  -h|--help               Print this help message"
    exit
}

# geometry template, step parameter is modified
geo_file="square.geo"
# dimension of the mesh
dimension=3
# number of elements for single processor
n_elements_one=16000
# initial factor for step reduction
init_factor=0.16
# sequence for number of processors
cpus="1 2 3 4"
# log file
log_file=output.log

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -g|--geo)
        geo_file="$2"
        shift
    ;;
    -d|--dim)
        dimension="$2"
        shift
    ;;
    -e|--elems)
        n_elements_one="$2"
        shift
    ;;
    -i|--init)
        init_factor="$2"
        shift
    ;;
    --)
        shift
        cpus="$@"
        break
    ;;
    -h|--help)
        usage
        exit
    ;;
    *)
        echo "Invalid option: $1"
        usage
        exit
    ;;
esac
shift
done

echo "Geo file:     $geo_file"
echo "Dimension:    $dimension"
echo "CPUs:         $cpus"
echo "n_elements:   $n_elements_one"
echo "Init factor:  $init_factor"



#
# Creates mesh with number of elements close to given value 'n_elements_expect'.
#
# Implements combination of Newton-like and regula falsi method.
# he algorithm is far to be robust since number of elements is not monotone function
# of the step size and moreover is very sensitive in particular for small meshes.
#
function make_mesh() {

export n_elements_expect=$((  $1 * $n_elements_one ))
export dimension
export log_file
export init_factor
echo "init_factor: ${init_factor}"

ulimit -v 2048000
perl <<'END'

  $n_elements_expect=$ENV{n_elements_expect};
  $dim=$ENV{dimension};
  $log_file=$ENV{log_file};
  $factor=$ENV{init_factor};

  $mesh_step=($n_elements_expect * $factor)**(-1.0/$dim);
  $rel_error=1;

  $lower_factor_bound=0;        $lower_step_bound=0;    # should be large step
  $upper_factor_bound=1e20;     $upper_step_bound=1e20; # should be small step

  while ( abs($rel_error) > 0.1 ) {
        # set mesh step
        system( "cat mesh_template.geo  | sed -e '/^step/s/.*/step=$mesh_step;/'  >mesh.geo" );
        system( "cat mesh.geo | head -n 2" );

        print "Meshing with step = $mesh_step ...";
        # algorithms 2d: del2d, front2d meshadapt
        # algorithms 3d: del3d, front3d
        system( "gmsh -$dim  -algo front3d mesh.geo -optimize -optimize_netgen -o mesh.msh >>$log_file" );
        $n_elements=`grep -A 1 "\\\$Elements" mesh.msh | tail -n 1`;
        $factor=$n_elements / $n_elements_expect;
        print " $n_elements elements; factor: $factor\n";
        $rel_error=1-$factor;
        $output_factor=$mesh_step**(-$dim)/$n_elements_expect;

        if ($factor > 1.0 ) {
            $upper_factor_bound=$factor;
            $upper_step_bound=$mesh_step;
        }
        if ($factor < 1.0 ) {
            $lower_factor_bound=$factor;
            $lower_step_bound=$mesh_step;
        }

        if ( $upper_step_bound < $lower_step_bound ) {
            # binary search
            #$mesh_step=( $upper_step_bound + $lower_step_bound) / 2;

            # regula falsi
            $mesh_step=$lower_step_bound + ( 1.0 - $lower_factor_bound)/($upper_factor_bound - $lower_factor_bound) * ( $upper_step_bound - $lower_step_bound);
        } else {
            # linear estimate
            $mesh_step=$mesh_step * $factor**(1.0/$dim);
        }

        print "$lower_factor_bound $factor $upper_factor_bound ; $lower_step_bound $mesh_step $upper_step_bound ; $rel_error \n";
  }
  print "$output_factor\n";
END

}

# sequence for number of processors (increasing)
for np in $cpus
do
  dir_name=${np}_tmp
  if [ -d $dir_name ]; then rm -r $dir_name; fi
  mkdir $dir_name
  cd $dir_name
  cp ../$geo_file mesh_template.geo

  make_mesh ${np} | tee save.out
  init_factor=`cat save.out | tail -n 1`
  rm -f save.out
  cd ..

  n_elements=`grep -A 1 "\\\$Elements" ${dir_name}/mesh.msh | tail -n 1`;
  mv ${dir_name} ${np}_${n_elements}_el
done
