// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following
// Path is a just a straight line in this example
// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = true;

// A path object (series of connected points)
Path path;

// Two vehicles
Vehicle car1;
Vehicle car2;

void setup() {
  size(640, 360);
  path = new Path();

  // Each vehicle has different maxspeed and maxforce for demo purposes
  car1 = new Vehicle(new PVector(0, height/2), 2, 0.02);
  car2 = new Vehicle(new PVector(0, height/2), 3, 0.05);
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
  car1.follow(path);
  car2.follow(path);
  // Call the generic run method (update, borders, display, etc.)
  car1.run();
  car2.run();
  
  // Check if it gets to the end of the path since it's not a loop
  car1.borders(path);
  car2.borders(path);
  
  // Instructions
  fill(0);
  text("Hit space bar to toggle debugging lines.", 10, height-30);
}

public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following

class Path {

  // A Path is line between two points (PVector objects)
  PVector start;
  PVector end;
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  Path() {
    // Arbitrary radius of 20
    radius = 20;
    start = new PVector(0,height/3);
    end = new PVector(width,2*height/3);
  }

  // Draw the path
  void display() {

    strokeWeight(radius*2);
    stroke(0,100);
    line(start.x,start.y,end.x,end.y);

    strokeWeight(1);
    stroke(0);
    line(start.x,start.y,end.x,end.y);
  }
}











// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2009

// Vehicle class

class Vehicle {

  // All the usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    // Constructor initialize all values
  Vehicle( PVector l, float ms, float mf) {
    position = l.get();
    r = 4.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(maxspeed, 0);
  }

  // Main "run" function
  void run() {
    update();
    display();
  }


  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  void follow(Path p) {

    // Predict position 50 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(50);
    PVector predictpos = PVector.add(position, predict);

    // Look at the line segment
    PVector a = p.start;
    PVector b = p.end;

    // Get the normal point to that line
    PVector normalPoint = getNormalPoint(predictpos, a, b);

    // Find target point a little further ahead of normal
    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);  // This could be based on velocity instead of just an arbitrary 10 pixels
    PVector target = PVector.add(normalPoint, dir);

    // How far away are we from the path?
    float distance = PVector.dist(predictpos, normalPoint);
    // Only if the distance is greater than the path's radius do we bother to steer
    if (distance > p.radius) {
      seek(target);
    }


    // Draw the debugging stuff
    if (debug) {
      fill(0);
      stroke(0);
      line(position.x, position.y, predictpos.x, predictpos.y);
      ellipse(predictpos.x, predictpos.y, 4, 4);

      // Draw normal position
      fill(0);
      stroke(0);
      line(predictpos.x, predictpos.y, normalPoint.x, normalPoint.y);
      ellipse(normalPoint.x, normalPoint.y, 4, 4);
      stroke(0);
      if (distance > p.radius) fill(255, 0, 0);
      noStroke();
      ellipse(target.x+dir.x, target.y+dir.y, 8, 8);
    }
  }


  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
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

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }


  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target

    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

      applyForce(steer);
  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(PConstants.TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders(Path p) {
    if (position.x > p.end.x + r) {
      position.x = p.start.x - r;
      position.y = p.start.y + (position.y-p.end.y);
    }
  }
}
