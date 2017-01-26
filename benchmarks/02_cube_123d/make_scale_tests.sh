#!/bin/bash

#
#  Script for preparation of input data for weak scaling tests.
#
#set -x

#FLOW_DIR=${HOME}/workspace/flow123d/branches/trunk_1.8

# geometry template, step parameter is modified
GEO_FILE="cube_123d.geo"

# number of elements for single processor
n_elements_one=16000

log_file=output.log


# dimension of the mesh
dimension=3
# initial factor for step reduction
init_factor=0.16;

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
for np in 1 2 3 #4 6 8 12 16  24  32 #48  64  96  128  #192  256 384  512 768  1024
#1 2 4  8 16  24  32 48  64  96  128  #192  256 384  512 768  1024
do
  dir_name=${np}_tmp
  if [ -d $dir_name ]; then rm -r $dir_name; fi
  mkdir $dir_name
  cd $dir_name
  cp ../$GEO_FILE mesh_template.geo 
 
  make_mesh ${np} | tee save.out 
  init_factor=`cat save.out | tail -n 1`
  rm -f save.out
  cd ..
  
  n_elements=`grep -A 1 "\\\$Elements" ${dir_name}/mesh.msh | tail -n 1`;
  mv ${dir_name} ${np}_${n_elements}_el
done
