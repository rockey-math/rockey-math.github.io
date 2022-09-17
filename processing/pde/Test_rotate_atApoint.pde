// https://stackoverflow.com/questions/51620952/how-to-rotate-a-3d-object-around-another-point-in-processing

float myAngle=-90; // degree measurement
float angle2=-45; // degree measurement

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
  // rotateZ(radians(angle2));
  
  pushMatrix();
  rotateY(radians(myAngle));
  rotateZ(radians(angle2));
  translate(158, 448, -10); 
  fill (color(2, 2, 222)); // blue            내 관심사는 어떻게 파랑과 빨강을 공전도 하면서 스스로 저전을 돌게 하는 것일까 하는것인데...
  box(40); // only one parameter: box(size);
  popMatrix();
  
  // 1. push(트랜슬레이트 + 로테이트는)pop : 이동한 지점에서 자전한다.
  // 2. push(로테이트 + 트랜슬레이트는)pop : 원점에서 자전하던 것을 원점을 중심으로 원점을 바라보는 공전으로 바꿀뿐. 자전은 하지 않는다.
  // 결국 위의 두가지 방법 뿐인듯하다. 공전하면서 자전하게 하는 방법은... 이 방법으로는 안된다. 함수로 한다면 몰를까.  로테이트1 + 트랜슬레이트 1 + 로테이트 2 라면?
  // 푸쉬와 팝 밖에서 트랜슬레이트와 로테이트를 하고 안에서 하는것은 다르다. 
  
  // 
  myAngle+=3; // speed
  angle2+=1;
  if (myAngle>=360) {
    myAngle=0; // keep in degree
  }
  if (angle2 >=360) {
    angle2=0; // keep in degree
    }
  //
}
