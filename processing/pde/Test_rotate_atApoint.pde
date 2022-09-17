// https://stackoverflow.com/questions/51620952/how-to-rotate-a-3d-object-around-another-point-in-processing

float myAngle=-90; // degree measurement

void setup () {
  // Init
  // 3D requires P3D or OPENGL as a parameter to size()
  size (600, 600, P3D);
}

void draw () {
  // repeated continously
  background(22);
  // switch on lights  
  lights();
  // color for lines
  stroke(111);
  // 
  // Box: A box with equal dimension on all sides is a cube.
  // red: in a distance around Y-axis
  pushMatrix();
  rotateY(radians(myAngle));
  translate(158, 148, -10); 
  fill (color(242, 2, 2));  // red
  box(40); // only one parameter: box(size);
  popMatrix();
  // 
  // Box: A box with equal dimension on all sides is a cube.
  // green: around itself 
  pushMatrix();
  translate(258, 448, -10); 
  rotateY(radians(myAngle));
  fill (color(2, 222, 2)); // green
  box(40); // only one parameter: box(size);
  popMatrix();
  //
  // Box: A box with equal dimension on all sides is a cube.
  // blue: around the green box
  translate(258, 0, 0); 
  pushMatrix();
  rotateY(radians(myAngle));
  translate(158, 448, -10); 
  fill (color(2, 2, 222)); // blue
  box(40); // only one parameter: box(size);
  popMatrix();
  // 
  myAngle+=3; // speed
  if (myAngle>=360) {
    myAngle=0; // keep in degree
  }
  //
}
