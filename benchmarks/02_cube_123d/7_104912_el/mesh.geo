step=0.0345968783894437;
Point(1) = {0, 0, 0, step};
Point(2) = {1, 0, 0, step};
Point(3) = {1, 0, 1, step};
Point(4) = {0, 0, 1, step};
Point(5) = {0, 1, 1, step};
Point(6) = {1, 1, 1, step};
Point(7) = {0, 1, 0, step};
Point(8) = {1, 1, 0, step};
Point(9) = {0.5, 0, 0.5, step};
Point(10) = {0.5, 1, 0.5, step};
Line(1) = {4, 1};
Line(2) = {1, 9};
Line(3) = {9, 4};
Line(4) = {4, 3};
Line(5) = {3, 9};
Line(6) = {9, 2};
Line(7) = {2, 3};
Line(8) = {2, 1};
Line(9) = {1, 7};
Line(10) = {7, 5};
Line(11) = {4, 5};
Line(12) = {7, 10};
Line(13) = {10, 5};
Line(14) = {5, 6};
Line(15) = {6, 10};
Line(16) = {10, 8};
Line(17) = {8, 6};
Line(18) = {8, 7};
Line(19) = {6, 3};
Line(20) = {2, 8};
Line(21) = {10, 9};
Line Loop(22) = {12, 21, -2, 9};
Plane Surface(23) = {22};
Line Loop(24) = {15, 21, -5, -19};
Plane Surface(25) = {24};
Line Loop(26) = {13, -11, -3, -21};
Plane Surface(27) = {26};
Line Loop(28) = {21, 6, 20, -16};
Plane Surface(29) = {28};
Line Loop(30) = {12, 16, 18};
Plane Surface(31) = {30};
Line Loop(32) = {15, 16, 17};
Plane Surface(33) = {32};
Line Loop(34) = {15, 13, 14};
Plane Surface(35) = {34};
Line Loop(36) = {13, -10, 12};
Plane Surface(37) = {36};
Line Loop(38) = {3, 4, 5};
Plane Surface(39) = {38};
Line Loop(40) = {5, 6, 7};
Plane Surface(41) = {40};
Line Loop(42) = {6, 8, 2};
Plane Surface(43) = {42};
Line Loop(44) = {3, 1, 2};
Plane Surface(45) = {44};
Line Loop(46) = {11, -10, -9, -1};
Plane Surface(47) = {46};
Line Loop(48) = {11, 14, 19, -4};
Plane Surface(49) = {48};
Line Loop(50) = {17, 19, -7, 20};
Plane Surface(51) = {50};
Line Loop(52) = {18, -9, -8, 20};
Plane Surface(53) = {52};
Surface Loop(54) = {23, 29, 31, 53, 43};
Volume(55) = {54};
Surface Loop(56) = {33, 51, 41, 29, 25};
Volume(57) = {56};
Surface Loop(58) = {35, 49, 39, 27, 25};
Volume(59) = {58};
Surface Loop(60) = {37, 47, 45, 23, 27};
Volume(61) = {60};

Physical Line("1d_channel") = {21};
Physical Surface("2d_frac") = {23, 25, 29, 27};
Physical Volume("3d_cube") = {55, 61, 59, 57};

Physical Surface(".3d_top_z") = {49};
Physical Surface(".3d_bottom_z") = {53};
Physical Surface(".3d_front_cross_y") = { 41, 43, 45, 39};
Physical Surface(".3d_back_cross_y") = { 37, 35, 31, 33};
Physical Surface(".3d_left_x") = {47};
Physical Surface(".3d_right_x") = {51};
Physical Line(".2d_top_z") = {11, 19};
Physical Line(".2d_bottom_z") = {9, 20};
Physical Line(".2d_front_y") = {2,3,5,6};
Physical Line(".2d_back_y") = {12, 15, 13, 16};
Physical Point(".1d_front_y") = {9};
Physical Point(".1d_back_y") = {10};
