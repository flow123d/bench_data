// 3D cube with fractures

// following option is necessary for generation of very fine meshes
// random factor times mesh step has to be greater then machine precision 
Mesh.RandomFactor=1e-5;

size = 12;

// left, front, bottom corner
X0 = 0;
X1 = 0;
X2 = 0;

// right, rear, top corner
Y0 = size;
Y1 = size;
Y2 = size;

// mesh step
mesh = 0.2;

// fractures
frac1 = 3*mesh;
frac2 = 7*mesh;

Point(1)  = {X0, X1, X2, mesh}; // Left
Point(2)  = {X0, X1, Y2, mesh};
Point(3)  = {X0, Y1, Y2, mesh};
Point(4)  = {X0, Y1, X2, mesh};
Point(5)  = {Y0, X1, X2, mesh}; // Right
Point(6)  = {Y0, X1, Y2, mesh};
Point(7)  = {Y0, Y1, Y2, mesh};
Point(8)  = {Y0, Y1, X2, mesh};
Point(9)  = {frac1, X1, X2, mesh}; // Frac left+1
Point(10) = {frac1, X1, Y2, mesh};
Point(11) = {frac1, Y1, Y2, mesh};
Point(12) = {frac1, Y1, X2, mesh};
Point(13) = {frac2, X1, X2, mesh}; // Frac left+2
Point(14) = {frac2, X1, Y2, mesh};
Point(15) = {frac2, Y1, Y2, mesh};
Point(16) = {frac2, Y1, X2, mesh};
Point(17) = {(Y0-X0)/2, X1, X2, mesh}; // Frac center
Point(18) = {(Y0-X0)/2, X1, Y2, mesh};
Point(19) = {(Y0-X0)/2, Y1, Y2, mesh};
Point(20) = {(Y0-X0)/2, Y1, X2, mesh};
Point(21) = {Y0-frac2, X1, X2, mesh}; // Frac right-2
Point(22) = {Y0-frac2, X1, Y2, mesh};
Point(23) = {Y0-frac2, Y1, Y2, mesh};
Point(24) = {Y0-frac2, Y1, X2, mesh};
Point(25) = {Y0-frac1, X1, X2, mesh}; // Frac right-1
Point(26) = {Y0-frac1, X1, Y2, mesh};
Point(27) = {Y0-frac1, Y1, Y2, mesh};
Point(28) = {Y0-frac1, Y1, X2, mesh};

Line(1)  = {1, 2}; // Left
Line(2)  = {2, 3};
Line(3)  = {3, 4};
Line(4)  = {4, 1};
Line(5)  = {5, 6}; // Right
Line(6)  = {6, 7};
Line(7)  = {7, 8};
Line(8)  = {8, 5};
Line(9)  = {9, 10}; // Frac left+1
Line(10) = {10, 11};
Line(11) = {11, 12};
Line(12) = {12, 9};
Line(13) = {13, 14}; // Frac left+2
Line(14) = {14, 15};
Line(15) = {15, 16};
Line(16) = {16, 13};
Line(17) = {17, 18}; // Frac center
Line(18) = {18, 19};
Line(19) = {19, 20};
Line(20) = {20, 17};
Line(21) = {21, 22}; // Frac right-2
Line(22) = {22, 23};
Line(23) = {23, 24};
Line(24) = {24, 21};
Line(25) = {25, 26}; // Frac right-1
Line(26) = {26, 27};
Line(27) = {27, 28};
Line(28) = {28, 25};
Line(29) = {1, 9}; // Left - Frac left+1
Line(30) = {2, 10};
Line(31) = {3, 11};
Line(32) = {4, 12};
Line(33) = {9, 13}; // Frac left+1 - Frac left+2
Line(34) = {10, 14};
Line(35) = {11, 15};
Line(36) = {12, 16};
Line(37) = {13, 17}; // Frac left+2 - Frac center
Line(38) = {14, 18};
Line(39) = {15, 19};
Line(40) = {16, 20};
Line(41) = {17, 21}; // Frac center - Frac right-2
Line(42) = {18, 22};
Line(43) = {19, 23};
Line(44) = {20, 24};
Line(45) = {21, 25}; // Frac right-2 - Frac right-1
Line(46) = {22, 26};
Line(47) = {23, 27};
Line(48) = {24, 28};
Line(49) = {25, 5}; // Frac right-1 - Right
Line(50) = {26, 6};
Line(51) = {27, 7};
Line(52) = {28, 8};

Line Loop(53) = {1, 2, 3, 4}; // Left boudary
Plane Surface(54) = {53};
Line Loop(55) = {9, 10, 11, 12}; // Frac left+1
Plane Surface(56) = {55};
Line Loop(57) = {13, 14, 15, 16}; // Frac left+2
Plane Surface(58) = {57};
Line Loop(59) = {17, 18, 19, 20}; // Frac center
Plane Surface(60) = {59};
Line Loop(61) = {21, 22, 23, 24}; // Frac right-1
Plane Surface(62) = {61};
Line Loop(63) = {25, 26, 27, 28}; // Frac right-1
Plane Surface(64) = {63};
Line Loop(65) = {5, 6, 7, 8}; // Right boundary
Plane Surface(66) = {65};

Line Loop(67) = {1, 30, -9, -29}; // Left - Frac left+1
Plane Surface(68) = {67};
Line Loop(69) = {2, 31, -10, -30};
Plane Surface(70) = {69};
Line Loop(71) = {3, 32, -11, -31};
Plane Surface(72) = {71};
Line Loop(73) = {4, 29, -12, -32};
Plane Surface(74) = {73};
Surface Loop(75) = {54, 56, 68, 70, 72, 74};
Volume(76) = {75};

Line Loop(77) = {9, 34, -13, -33}; // Frac left+1 - Frac left+2
Plane Surface(78) = {77};
Line Loop(79) = {10, 35, -14, -34};
Plane Surface(80) = {79};
Line Loop(81) = {11, 36, -15, -35};
Plane Surface(82) = {81};
Line Loop(83) = {12, 33, -16, -36};
Plane Surface(84) = {83};
Surface Loop(85) = {56, 58, 78, 80, 82, 84};
Volume(86) = {85};

Line Loop(87) = {13, 38, -17, -37}; // Frac left+2 - Frac center
Plane Surface(88) = {87};
Line Loop(89) = {14, 39, -18, -38};
Plane Surface(90) = {89};
Line Loop(91) = {15, 40, -19, -39};
Plane Surface(92) = {91};
Line Loop(93) = {16, 37, -20, -40};
Plane Surface(94) = {93};
Surface Loop(95) = {58, 60, 88, 90, 92, 94};
Volume(96) = {95};

Line Loop(97) = {17, 42, -21, -41}; // Frac center - Frac right-2
Plane Surface(98) = {97};
Line Loop(99) = {18, 43, -22, -42};
Plane Surface(100) = {99};
Line Loop(101) = {19, 44, -23, -43};
Plane Surface(102) = {101};
Line Loop(103) = {20, 41, -24, -44};
Plane Surface(104) = {103};
Surface Loop(105) = {60, 62, 98, 100, 102, 104};
Volume(106) = {105};

Line Loop(107) = {21, 46, -25, -45}; // Frac right-2 - Frac right-1
Plane Surface(108) = {107};
Line Loop(109) = {22, 47, -26, -46};
Plane Surface(110) = {109};
Line Loop(111) = {23, 48, -27, -47};
Plane Surface(112) = {111};
Line Loop(113) = {24, 45, -28, -48};
Plane Surface(114) = {113};
Surface Loop(115) = {62, 64, 108, 110, 112, 114};
Volume(116) = {115};

Line Loop(117) = {25, 50, -5, -49}; // Frac right-1 - Right
Plane Surface(118) = {117};
Line Loop(119) = {26, 51, -6, -50};
Plane Surface(120) = {119};
Line Loop(121) = {27, 52, -7, -51};
Plane Surface(122) = {121};
Line Loop(123) = {28, 49, -8, -52};
Plane Surface(124) = {123};
Surface Loop(125) = {64, 66, 118, 120, 122, 124};
Volume(126) = {125};

// bulk
Physical Surface("2d_fracture_1") = {56};
Physical Surface("2d_fracture_2") = {58};
Physical Surface("2d_fracture_3") = {60};
Physical Surface("2d_fracture_4") = {62};
Physical Surface("2d_fracture_5") = {64};
Physical Volume("bulk") = {76, 86, 96, 106, 116, 126};

// boundary
// Physical Point(".1d_chanel") = {10, 9};
// Physical Line(".2d_fracture_1") = {12, 2, 9, 15, 5, 19};
// Physical Line(".2d_fracture_2") = {13, 11, 3, 6, 20, 16};
// Physical Surface(".3d_cube") = { 31, 53, 43, 33, 51, 41, 35, 49, 39, 37, 47, 45};
