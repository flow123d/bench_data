// random factor times mesh step has to be greater then machine precision 
Mesh.RandomFactor=1e-5;

size = 1;
 
// left, front, bottom corner
X0 = 0;
X1 = 0;
X2 = 0;

// right, rear, top corner
Y0 = 0;
Y1 = size;
Y2 = size;

// steps setting
n_steps = 12;
mesh = size / n_steps / 2;


// regions
Physical Volume("bulk") = { };
Physical Surface("2d_fracture") = { };
Physical Line("1d_fracture") = { };


Macro XZ_Slice

  // In the following commands we use the reserved variable name `newp', which
  // automatically selects a new point tag. Analogously to `newp', the special
  // variables `newl', `newll, `news', `newsl' and `newv' select new loop,
  // line loop, surface, surface loop and volume tags.
  //
  // If `Geometry.OldNewReg' is set to 0, the new tags are chosen as the highest
  // current tag for each category (points, curves, curve loops, ...), plus
  // one. By default, for backward compatibility, `Geometry.OldNewReg' is set
  // to 1, and only two categories are used: one for points and one for the
  // rest.

  p1  = newp; Point(p1)  = {X0, X1, X2, mesh};
  p2  = newp; Point(p2)  = {X0, X1, Y2, mesh};
  p3  = newp; Point(p3)  = {X0, Y1, Y2, mesh};
  p4  = newp; Point(p4)  = {X0, Y1, X2, mesh};
  p11 = newp; Point(p11) = {Y0, X1, X2, mesh};
  p12 = newp; Point(p12) = {Y0, X1, Y2, mesh};
  p13 = newp; Point(p13) = {Y0, Y1, Y2, mesh};
  p14 = newp; Point(p14) = {Y0, Y1, X2, mesh};

  l1  = newl; Line(l1)  = {p1,  p2};
  l2  = newl; Line(l2)  = {p2,  p3};
  l3  = newl; Line(l3)  = {p3,  p4};
  l4  = newl; Line(l4)  = {p4,  p1};
  l5  = newl; Line(l5)  = {p11, p12};
  l6  = newl; Line(l6)  = {p12, p13};
  l7  = newl; Line(l7)  = {p13, p14};
  l8  = newl; Line(l8)  = {p14, p11};
  l9  = newl; Line(l9)  = {p1,  p11};
  l10 = newl; Line(l10) = {p2,  p12};
  l11 = newl; Line(l11) = {p3,  p13};
  l12 = newl; Line(l12) = {p4,  p14};
  
  ll1 = newll; Line Loop(ll1) = {l1, l2, l3, l4};
  ll2 = newll; Line Loop(ll2) = {l5, l6, l7, l8};
  ll3 = newll; Line Loop(ll3) = {l1, l10, -l5, -l9};
  ll4 = newll; Line Loop(ll4) = {l2, l11, -l6, -l10};
  ll5 = newll; Line Loop(ll5) = {l3, l12, -l7, -l11};
  ll6 = newll; Line Loop(ll6) = {l4, l9, -l8, -l12};

  s1 = news; Plane Surface(s1) = { ll1 };
  s2 = news; Plane Surface(s2) = { ll2 };
  s3 = news; Plane Surface(s3) = { ll3 };
  s4 = news; Plane Surface(s4) = { ll4 };
  s5 = news; Plane Surface(s5) = { ll5 };
  s6 = news; Plane Surface(s6) = { ll6 };

  s_loop = newsl;
  Surface Loop(s_loop) = { s1, s2, s3, s4, s5, s6 };

  v = newv; 
  Volume(v) = s_loop;
  Physical Volume("bulk") += v;
  
  If(t < n_steps)
    Physical Surface("2d_fracture") += s2;
  EndIf
  If(u < n_steps)
    Physical Surface("2d_fracture") += s4;
    If(t < n_steps)
      Physical Line("1d_fracture") += l6;
    EndIf
  EndIf
  
Return


For t In {1:n_steps}

  X2 = 0;
  Y2 = 0;
  Y0 += 2 * mesh;

  For u In {1:n_steps}
    Y2 += 2 * mesh;
  
    // We call the `XZ_Slice' macro:
    Call XZ_Slice;
    
    X2 += 2 * mesh;
  EndFor

  X0 += 2 * mesh;

EndFor

