// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Stay Within Circle
// "Made-up" Steering behavior to stay within walls

Vehicle v;
boolean debug = true;


PVector circleposition;
float circleRadius;



void setup() {
  size(640, 360);
  v = new Vehicle(width/2, height/4);
  
  circleposition = new PVector(width/2,height/2);
  circleRadius = height/2-25;
}

void draw() {
  background(255);

  if (debug) {
    stroke(175);
    noFill();
    ellipse(circleposition.x,circleposition.y, circleRadius*2,circleRadius*2);
  }

  v.boundaries();
  v.run();
}

void mousePressed() {
  debug = !debug;
}




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Vehicle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;

  float maxspeed;
  float maxforce;
  
  Vehicle(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1,0);
    velocity.mult(5);
    position = new PVector(x, y);
    r = 3;
    maxspeed = 3;
    maxforce = 0.15;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void boundaries() {

    PVector desired = null;
    
    // Predict position 25 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.mult(25);
    PVector futureposition = PVector.add(position, predict);
    float distance = PVector.dist(futureposition,circleposition);
    
    if (distance > circleRadius) {
      PVector toCenter = PVector.sub(circleposition,position);
      toCenter.normalize();
      toCenter.mult(velocity.mag());
      desired = PVector.add(velocity,toCenter);
      desired.normalize();
      desired.mult(maxspeed);
    }

    if (desired != null) {
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
    
    fill(255,0,0);
    ellipse(futureposition.x,futureposition.y,4,4);
    
  }  

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }


  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }
}

