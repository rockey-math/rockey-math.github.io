// https://forum.processing.org/one/topic/3d-rotation-logic-problem.html
int valueX = 90, valueY = 45, valueZ = 0;

void setup () {
size (600, 600, P3D);
}
void draw () {
background(22);
lights();

stroke(111);
line(100,500,-200,800,500,-200); // x
line(100,500,-200,100,0,-200); // y
line(100,500,-200,100,500,200); // z

translate(250, 400, -10);

// white basic box
fill(255, 255, 255);
box(30, 200, 30);

// red box rotated one axis at a time (axis "stick" to the object itself)
pushMatrix();
fill(255, 0, 0);
rotateX(radians(valueX));
rotateY(radians(valueY));
rotateZ(radians(valueZ));
box(30, 200, 30);
popMatrix();

// green box rotated three axis at once (axis "stick" to the world/"ground")
fill(0, 255, 0);
rotateXYZ(radians(valueX), radians(valueY), radians(valueZ));
box(30, 200, 30);
}

// BFG function
void rotateXYZ(float xx, float yy, float zz) {
float cx, cy, cz, sx, sy, sz;

cx = cos(xx);
cy = cos(yy);
cz = cos(zz);
sx = sin(xx);
sy = sin(yy);
sz = sin(zz);

applyMatrix(cy*cz, (cz*sx*sy)-(cx*sz), (cx*cz*sy)+(sx*sz), 0.0,
cy*sz, (cx*cz)+(sx*sy*sz), (-cz*sx)+(cx*sy*sz), 0.0,
-sy, cy*sx, cx*cy, 0.0,
0.0, 0.0, 0.0, 1.0);
}
