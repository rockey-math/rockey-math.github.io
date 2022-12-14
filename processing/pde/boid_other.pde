// https://github.com/womogenes/Boids/blob/main/Boid.pde
// https://www.youtube.com/watch?v=x-GwBH4dhko

int n; // How many boids we have.
float sCoef;
float aCoef;
float cCoef;
float radius;

float maxSpeed;
float maxForce;

Boid[] boids;

PShape boidShape;


void setup() {
  size(900, 720, P2D);
  // fullScreen();
  frameRate(60);
  
  n = 50;
  aCoef = 0.3;
  sCoef = 0.5;
  cCoef = 0.5;
  radius = 100;
  
  maxSpeed = 3;
  maxForce = 0.1;
  
  boids = new Boid[n];
  
  for (int i = 0; i < boids.length; i++) {
    boids[i] = new Boid(new PVector(random(0, width), random(0, height)), PVector.random2D());
  }
  
  /*
  
  // Uncaught ReferenceError: createShape is not defined. in processingJS
  // https://stackoverflow.com/questions/32066923/why-doesnt-this-processing-processing-js-sketch-show-when-i-run-it
  // 이게 안되니 쉐이프를 직접 그려주어야 하는듯하다. // KR 참조. 95라인부터.
  float shapeSize = 3;
  
  boidShape = createShape();      
  boidShape.beginShape();
  boidShape.strokeWeight(1.5);
  boidShape.noFill();
  boidShape.stroke(255);
  boidShape.vertex(shapeSize * 4, 0);
  boidShape.vertex(-shapeSize, shapeSize * 2);
  boidShape.vertex(0, 0);
  boidShape.vertex(-shapeSize, -shapeSize * 2);
  boidShape.endShape(CLOSE);
  */
  
 /*
  boidShape.beginShape();
  boidShape.fill(0, 0, 255);
  boidShape.noStroke();
  boidShape.vertex(0, 0);
  boidShape.vertex(0, 50);
  boidShape.vertex(50, 50);
  boidShape.vertex(50, 0);
  boidShape.endShape(CLOSE);
*/
}


void draw() {
  background(0);
  
  for (Boid b : boids) {
    b.update();
    b.display();
  }
}


class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  
  public Boid(PVector pos, PVector vel) {
    this.acc = new PVector();
    this.pos = pos;
    this.vel = vel;
  }
  
  void drawBoid(float x, float y, float heading) {
    float shapeSize = 2;  // KR
    pushMatrix();
    translate(x, y);
    rotate(heading);
    // shape(boidShape);   // KR   이 아래 부분에 직접 그림을 그려주어야 한다. 
      beginShape();
       strokeWeight(1.5);
       noFill();
       stroke(255);
       vertex(shapeSize * 4, 0);
       vertex(-shapeSize, shapeSize * 2);
       vertex(0, 0);
       vertex(-shapeSize, -shapeSize * 2);
      endShape(CLOSE);
    popMatrix();
  }
  
  void display() {
    drawBoid(pos.x, pos.y, vel.heading());
    if (pos.x < 50) {
      drawBoid(pos.x + width, pos.y, vel.heading());
    }
    if (pos.x > width - 50) {
      drawBoid(pos.x - width, pos.y, vel.heading());
    }
    if (pos.y < 50) {
      drawBoid(pos.x, pos.y + height, vel.heading());
    }
    if (pos.y > height - 50) {
      drawBoid(pos.x, pos.y - height, vel.heading());
    }
  }
  
  void separate() {
    PVector target = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      if (other != this && d < radius) {
        PVector diff = PVector.sub(pos, other.pos);
        diff.div(d * d);
        target.add(diff);
        total++;
      }
    }
    if (total == 0) return;
    
    target.div(total);
    target.setMag(maxSpeed);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(sCoef);
    acc.add(force);
  }
  
  void cohere() {
    PVector center = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      if (other != this && d < radius) {
        center.add(other.pos);
        total++;
      }
    }
    if (total == 0) return;
    center.div(total);
    PVector target = PVector.sub(center, pos);
    target.setMag(maxSpeed);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(cCoef);
    acc.add(force);
  }
  
  void align() {
    PVector target = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      if (other != this && d < radius) {
        target.add(other.vel);
        total++;
      }
    }
    if (total == 0) return;
    target.div(total);
    target.setMag(maxSpeed);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(aCoef);
    acc.add(force);
  }
  
  void wrap() {
    if (pos.x < 0) { pos.x = width; }
    else if (pos.x >= width) { pos.x = 0; }
    if (pos.y < 0) { pos.y = height; }
    else if (pos.y >= height) { pos.y = 0; }
  }
  
  void update() {
    acc = new PVector();
    wrap();
    align();
    cohere();
    separate();
    pos.add(vel);
    vel.add(acc);
    vel.limit(maxSpeed);
  }
}
