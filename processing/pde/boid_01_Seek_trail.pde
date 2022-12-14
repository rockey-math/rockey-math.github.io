// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Implements Craig Reynold's autonomous steering behaviors
// One vehicle "seeks"
// See: http://www.red3d.com/cwr/

Vehicle v;

void setup() {
  size(800, 200);
  v = new Vehicle(width/2, height/2);
}

void draw() {

  background(255);

  PVector mouse = new PVector(mouseX, mouseY);

  // Draw an ellipse at the mouse position
  fill(200);
  stroke(0);
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);

  // Call the appropriate steering behaviors for our agents
  v.seek(mouse);
  v.update();
  v.display();
}


// The Nature of Code
// Daniel Shiffman
// https://raw.githubusercontent.com/nature-of-code/noc-examples-processing/master/chp06_agents/NOC_6_01_Seek_trail/Vehicle.pde

// The "Vehicle" class

class Vehicle {
  ArrayList<PVector> history = new ArrayList<PVector>();

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,-2);
    position = new PVector(x,y);
    r = 6;
    maxspeed = 4;
    maxforce = 0.1;
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
    
    history.add(position.get());
    if (history.size() > 100) {
      history.remove(0);
    }
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    applyForce(steer);
  }
    
  void display() {

    beginShape();
    stroke(0);
    strokeWeight(1);
    noFill();
    for(PVector v: history) {
      vertex(v.x,v.y);
    }
    endShape();
    
    
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
      translate(position.x,position.y);
      rotate(theta);
      println('theta = ' + theta*180/PI);
      beginShape();
        vertex(0, -r*2);
        vertex(-r, r*2);
        vertex(r, r*2);
      endShape(CLOSE);
    popMatrix();
    
    
  }
}
