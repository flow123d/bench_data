#!/usr/bin/python
# -*- coding: utf-8 -*-
# author:   Jan Hybs

"""
This script will generate mesh files and will setup yaml files
  based on given option
"""

import argparse
import subprocess
import os
from shutil import copyfile


class SmartFormatter(argparse.HelpFormatter):
    def _split_lines(self, text, width):
        if text.startswith('R|'):
            return [l.lstrip() for l in text[2:].lstrip().splitlines()]
            # this is the RawTextHelpFormatter._split_lines
        return argparse.HelpFormatter._split_lines(self, text, width)


def configure(content, **kwargs):
    """
    Similar to cmake's configure_file
    """
    for key, value in kwargs.items():
        content = content.replace('@{key}@'.format(key=key), str(value))
    return content


parser = argparse.ArgumentParser('generate.py', formatter_class=SmartFormatter)
parser.add_argument('-g', dest='geo_file', metavar='GEO_FILE', required=True, help="""R|
    Location of the geo file, which will be configured. In this file you have to configurable values:
    @cl@ - characteristic length
    @comment@ - auto generated comment which states basic info about the file
""")
parser.add_argument('-c', dest='config_yaml', metavar='CONFIG_YAML', required=True, help="""R|
    Specify config yaml file which will be only copied to output location (and renamed to config.yaml)
""")
parser.add_argument('-o', dest='output', metavar='DIR', default='01_square_regular_grid', help="""R|
    Output folder in which all files will be generated. Since this name will later by used 
    to identify test name, it should be same as this folder. Benchmark tests information are
    picked out from the path of the yaml file:
    <test-name>/<case-name>.yaml
""")
parser.add_argument('-y', dest='yaml_files', metavar='YAML_FILE', action='append', required=True, help="""R|
    Yaml files which should be configured. In template yaml file you can specify
    value @mesh_file@ which will be replaced with appropriate value. Thsi value
    point to mesh file relative path to this yaml file
""")
parser.add_argument('sizes', metavar='N', nargs='+', type=int, help="""R|
    Sequnce of integers designating line division, 
    given number 5 will set characteristic line length to 1/5
""")
opts = parser.parse_args()


# prepare mesh folder
mesh_dir = os.path.join(opts.output, 'mesh')
if not os.path.exists(mesh_dir):
    os.makedirs(mesh_dir)

# prepare output folder
output_dir = opts.output
if not os.path.exists(output_dir):
    os.makedirs(output_dir)


# 1) generate mesh
geo_filename = opts.geo_file.split('.')[0]
geo_content = open(opts.geo_file, 'r').read()
for size in opts.sizes:
    new_geo_filename = os.path.join(mesh_dir, '{geo_filename}_{size}.geo'.format(**locals()))
    new_msh_filename = new_geo_filename.replace('.geo', '.msh')

    new_geo_content = configure(geo_content,
                                comment='Square mesh {size}x{size} elements'.format(**locals()),
                                cl='1/{size}'.format(**locals()),
                                )
    open(new_geo_filename, 'w').write(new_geo_content)
    command = ['gmsh', new_geo_filename, '-2', '-o', new_msh_filename]
    print('-' * 60)
    print('Generating mesh with size {}'.format(size))
    print('-' * 60)
    output = subprocess.check_output(command).strip().decode()
    print(output)

    # 2) generate yaml files
    for y in opts.yaml_files:
        yaml_filename = y.split('.')[0]
        yaml_content = open(y, 'r').read()

        new_yaml_filename = os.path.join(output_dir, '{yaml_filename}_{size}.yaml'.format(**locals()))
        relative_path = os.path.relpath(new_msh_filename, os.path.dirname(new_yaml_filename))
        new_yaml_content = configure(yaml_content,
                                     mesh_file=relative_path)
        open(new_yaml_filename, 'w').write(new_yaml_content)
    
    # 3) copy config yaml
    copyfile(opts.config_yaml, os.path.join(output_dir, 'config.yaml'))
