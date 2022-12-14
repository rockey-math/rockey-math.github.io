// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flocking

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

Flock flock;

void setup() {
  size(640,360);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0,0);
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 50; i++) {
    flock.addBoid(new Boid(new PVector(random(width),random(height))));
  }
}

void draw() {
  // We must always step through time!
  box2d.step();

  background(255);
  flock.run();
}

void mousePressed() {
   flock.addBoid(new Boid(new PVector(mouseX,mouseY)));
}

void mouseDragged() {
   flock.addBoid(new Boid(new PVector(mouseX,mouseY)));
}




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flocking

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An arraylist for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the arraylist
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flocking

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Boid(PVector pos) {
    w = 12;
    h = 12;
    // Add the box to the box2d world
    makeBody(new Vec2(pos.x,pos.y),w,h,new Vec2(0,0),0);
    maxspeed = 20;
    maxforce = 10;
  }
  
  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    borders();
    display();
  }
  
  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    Vec2 sep = separate(boids);   // Separation
    Vec2 ali = align(boids);      // Alignment
    Vec2 coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mulLocal(1.5);
    ali.mulLocal(1);
    coh.mulLocal(1);
    // Add the force vectors to acceleration
    Vec2 loc = body.getWorldCenter();
    body.applyForce(sep,loc);
    body.applyForce(ali,loc);
    body.applyForce(coh,loc);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  Vec2 seek(Vec2 target) {
    Vec2 loc = body.getWorldCenter();
    Vec2 desired = target.sub(loc);  // A vector pointing from the position to the target

    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.length() == 0) return new Vec2(0,0);

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mulLocal(maxspeed);
    // Steering = Desired minus Velocity
    
    Vec2 vel = body.getLinearVelocity();
    Vec2 steer = desired.sub(vel);
    
    float len = steer.length();
    if (len > maxforce) {
      steer.normalize();
      steer.mulLocal(maxforce);
    }
    return steer;
  }
  


  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(175);
    strokeWeight(2);
    stroke(0);
    rect(0,0,w,h);
    popMatrix();
  }

  // Wraparound
  void borders() {
    Vec2 loc = box2d.getBodyPixelCoord(body); 
    Vec2 vel = body.getLinearVelocity();
    float a = body.getAngularVelocity();
    if (pos.x < -w) {
       killBody();
       makeBody(new Vec2(width+w,pos.y),w,h,vel,a);
    } else if (pos.y < -w) {
       killBody();
       makeBody(new Vec2(pos.x,height+w),w,h,vel,a);
    } else if (pos.x > width+w) {
       killBody();
       makeBody(new Vec2(-w,pos.y),w,h,vel,a);
    } else if (pos.y > height+w) {
       killBody();
       makeBody(new Vec2(pos.x,-w),w,h,vel,a);  
    }
  }

  // Separation
  // Method checks for nearby boids and steers away
  Vec2 separate (ArrayList<Boid> boids) {
    float desiredseparation = box2d.scalarPixelsToWorld(30);
    
    Vec2 steer = new Vec2(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    Vec2 locA = body.getWorldCenter();
    for (Boid other : boids) {
      Vec2 locB = other.body.getWorldCenter();
      float d = dist(locA.x,locA.y,locB.x,locB.y);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        Vec2 diff = locA.sub(locB);
        diff.normalize();
        diff.mulLocal(1.0/d);        // Weight by distance
        steer.addLocal(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.mulLocal(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.length() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mulLocal(maxspeed);
      Vec2 vel = body.getLinearVelocity();
      steer.subLocal(vel);
      float len = steer.length();
      if (len > maxforce) {
        steer.normalize();
        steer.mulLocal(maxforce);
      }
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  Vec2 align (ArrayList<Boid> boids) {
    float neighbordist = box2d.scalarPixelsToWorld(50);
    Vec2 steer = new Vec2(0,0);
    int count = 0;
    Vec2 locA = body.getWorldCenter();
    for (Boid other : boids) {
      Vec2 locB = other.body.getWorldCenter();
      float d = dist(locA.x,locA.y,locB.x,locB.y);
      if ((d > 0) && (d < neighbordist)) {
        Vec2 vel = other.body.getLinearVelocity();
        steer.addLocal(vel);
        count++;
      }
    }
    if (count > 0) {
      steer.mulLocal(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.length() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mulLocal(maxspeed);
      Vec2 vel = body.getLinearVelocity();
      steer.subLocal(vel);
      float len = steer.length();
      if (len > maxforce) {
        steer.normalize();
        steer.mulLocal(maxforce);
      }
    }
    return steer;
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  Vec2 cohesion (ArrayList<Boid> boids) {
    float neighbordist = box2d.scalarPixelsToWorld(50);
    Vec2 sum = new Vec2(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    Vec2 locA = body.getWorldCenter();
    for (Boid other : boids) {
      Vec2 locB = other.body.getWorldCenter();
      
      float d = dist(locA.x,locA.y,locB.x,locB.y);
      if ((d > 0) && (d < neighbordist)) {
        sum.addLocal(locB); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.mulLocal(1.0/count);
      return seek(sum);  // Steer towards the position
    }
    return sum;
  }
  
  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_, Vec2 vel, float avel) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    
    body.setLinearVelocity(vel);
    body.setAngularVelocity(avel);

  }
  
  
}


