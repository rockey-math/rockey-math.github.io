// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/akM4wMZIBWg

// import peasy.*;

// PeasyCam cam;

PVector[][] globe;
int total = 75;

float offset = 0;

float m = 0;
float mchange = 0;


void setup() {
  size(800, 800, P3D);
  // cam = new PeasyCam(this, 500);
  colorMode(HSB);
  globe = new PVector[total+1][total+1];
}

float a = 1;
float b = 1;

float supershape(float theta, float m, float n1, float n2, float n3) {
  float t1 = abs((1/a)*cos(m * theta / 4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, - 1 / n1);
  return r;
}

void draw() {
  background(0);
  // noStroke();
  // lights();
  
  translate(width/2, height/2);
  rotateZ(-45*PI/180);
  rotateX(-90*PI/180);
  rotateX(millis() * 0.0001);//animation
  rotateZ(millis() * 0.001);//animation
  
  noFill();
  stroke(255);
       
  m = map(sin(mchange), -1, 1, 0, 7);
  mchange += 0.02;
  
  float r = 200;
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    //float r2 = supershape(lat, m, 0.2, 1.7, 1.7);
    //float r2 = supershape(lat, 2, 10, 10, 10);
    float r2 = 1.0;
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      //float r1 = supershape(lon, m, 0.2, 1.7, 1.7);
      //float r1 = supershape(lon, 8, 60, 100, 30);
      float r1 = 1.0;
      float x = r * r1 * cos(lon) * r2 * cos(lat) + r/2* r1 * cos(5*lon) * r2 * cos(5*lat) + r/6* r1 * cos(-13*lon) * r2 * cos(-13*lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat) + r/2 * r1 * sin(5*lon) * r2 * cos(5*lat) + r/6 * r1 * sin(-13*lon) * r2 * cos(-13*lat);
      float z = r * r2 * sin(lat) + r/2 * r2 * sin(5*lat) + r/6 * r2 * sin(-13*lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }

  //stroke(255);
  //fill(255);
  //noFill();
  offset += 5;
  for (int i = 0; i < total; i++) {
    float hu = map(i, 0, total, 0, 255*6);
    fill((hu + offset) % 255 , 255, 255);
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++) {
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}
