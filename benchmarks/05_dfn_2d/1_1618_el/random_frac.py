import random

nf = 50

print "SetFactory(\"OpenCASCADE\");"
print "Rectangle(1) = { 0, 0, 0, 1, 1, 0 };"

po = 10;
for i in range(1,nf+1):
  print "Point(", po+2*i-1, ") = { ", random.random(), ", ", random.random(), ", 0 };"
  print "Point(", po+2*i, ") = { ", random.random(), ", ", random.random(), ", 0 };"
  print "Line(", po+i, ") = { ", po+2*i-1, ", ", po+2*i, " };"

print "fractures() = BooleanFragments{ Line{ ", po+1, " }; Delete; }{ Line{ ", po+2, ":", po+nf, " }; Delete; };"

print "Line { fractures() } In Surface { 1 };"
print "Physical Surface(\"rock\") = { 1 };"
print "Physical Line(\"fracture\") = { fractures() };"
print "Physical Line(\".left\") = { 4 };"
print "Physical Line(\".right\") = { 2 };"