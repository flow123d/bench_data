
import argparse
import subprocess
import os
from shutil import copyfile


# python3 generate.py 2 4 8 10 16 20 32 40 64 50 100 128 200 256 500 512

class SmartFormatter(argparse.HelpFormatter):

    def _split_lines(self, text, width):
        if text.startswith('R|'):
            return text[2:].splitlines()  
        # this is the RawTextHelpFormatter._split_lines
        return argparse.HelpFormatter._split_lines(self, text, width)
        

def configure(content, **kwargs):
    for key, value in kwargs.items():
        content = content.replace('@{key}@'.format(key=key), str(value))
    return content


parser = argparse.ArgumentParser('Generates mesh files', formatter_class=SmartFormatter)
parser.add_argument('--output', '-o', metavar='OUTPUT', type=str, default='square-{size}/', dest='output',
    help="""
R|Output directory with format which is configured.
Values which are replaced are:
  - {task_size} which will be replaced with actual number of task_size
  - {elements} number of all elements
  - {size} entered number
 
Simple example is:
python3 generate.py 10 100 -o default='square-{task_size}/'

will produce folders square-200/ and square-20000/
""".strip())

parser.add_argument('--copy', '-c', metavar='PATH', type=str, default=['transport.yaml'], dest='copy', nargs='+',
    help="files which are also copied to output dir")

parser.add_argument('--configure', '-f', metavar='PATH', type=str, default='square.geo', dest='config',
    help="""
R|File which configured using configuration rules @VARIABLE@,
for now only values which can be configured are:
  - @cl@ characteristic length on line
  - @comment@ auto generated comment containing basic info about geo file
""".strip())

parser.add_argument('--base', '-b', metavar='X', type=float, default=1.0, dest='base', help='Divident when generating msg size')
parser.add_argument('sizes', metavar='N', type=eval, nargs='+',
    help="""
R|Grid size (number of elements for one side). Characteristic length
is then computed as 1/value (values are divisors). Example:

python3 generate.py 5 10
will generate mesh
 - 5x5,   where each element is dived to two triangles, setting task size to 50
 - 10x10, where each element is dived to two triangles, setting task size to 200

Values can be ints or even python expressions:
python3 generate.py "[2**x for x in range(2, 5)]"

will evaluate expressions as list with values [4, 8, 16] and run generation process.
""".strip())

args = parser.parse_args()

base = args.base
values = list()
for f in args.sizes:
    if type(f) in (list, tuple, set):
        for v in f:
            values.append(
                ('{base}/{v}'.format(base=int(base), v=v), base / v)
            )
    else:
            values.append(
                ('{base}/{v}'.format(base=int(base), v=f), base / f)
            )

for step, value in values:
    size = int(1/value)
    elements = int((1/value) ** 2 * 2 + 4 * (1/value))
    task_size = int((1/value) ** 2 * 2)
    location = args.output.format(**locals())
    
    # create dir
    if not os.path.exists(location):
        os.makedirs(location)
    
    # copy files
    for c in args.copy:
        copyfile(c, os.path.join(location, c))
    
    # configure file
    mesh_file = os.path.join(location, args.config.replace('.geo', '.msh'))
    geo_file = os.path.join(location, args.config)
    content = configure(open(args.config, 'r').read(),
        cl=step,
        comment="Square mesh {size}x{size} having total of {task_size} elements".format(**locals())
        )
    open(geo_file, 'w').write(content)
    
    print('Generating mesh with size {}, location: {}'.format(task_size, location))
    command = [
        'gmsh', geo_file,
        '-2', '-o', mesh_file
    ]
    output = subprocess.check_output(command).strip().decode()
    print(output)