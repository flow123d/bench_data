step=0.00343039037501565;
l  = 1;   // size of square

Point(1) = { 0, 0, 0, step };
Point(2) = { l, 0, 0, step };
Line(3) = { 1, 2 };

Extrude{ 0, l, 0 }{ Line{ 3 };
Layers{ l/step }; }

Physical Line(".bottom") = { 3 };
Physical Line(".top") = { 4 };
Physical Line(".left") = { 5 };
Physical Line(".right") = { 6 };
Physical Surface("square") = { 7 };
