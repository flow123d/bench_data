// Square mesh 64x64 having total of 8192 elements

l  = 1;   // size of square
cl = 1/64; // characteristic length

Point(1) = { 0, 0, 0, cl };
Point(2) = { l, 0, 0, cl };
Line(3) = { 1, 2 };

Extrude{ 0, l, 0 }{ Line{ 3 }; Layers{ l/cl }; }

Physical Line(".bottom") = { 3 };
Physical Line(".top") = { 4 };
Physical Line(".left") = { 5 };
Physical Line(".right") = { 6 };
Physical Surface("square") = { 7 };
