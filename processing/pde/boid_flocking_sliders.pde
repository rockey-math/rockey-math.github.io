// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com


// Flocking
// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system
Flock flock;
PVector center;

boolean showvalues = true;
boolean scrollbar = false;


void setup() {
  size(displayWidth,displayHeight,P2D);
  setupScrollbars();
  center = new PVector(width/2,height/2);
  colorMode(RGB,255,255,255,100);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 120; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  smooth();
}


void draw() {

  background(255); 
  flock.run();
  drawScrollbars();

  if (mousePressed && !scrollbar) {
    flock.addBoid(new Boid(mouseX,mouseY));
  }


  if (showvalues) {
    fill(0);
    textAlign(LEFT);
    text("Total boids: " + flock.boids.size() + "\n" + "Framerate: " + round(frameRate) + "\nPress any key to show/hide sliders and text\nClick mouse to add more boids",5,100);
  }
}

void keyPressed() {
  showvalues = !showvalues;
}

void mousePressed() {
}




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Code based on "Scrollbar" by Casey Reas

HScrollbar[] hs = new HScrollbar[5];//
String[] labels =  {"separation", "alignment","cohesion","maxspeed","maxforce"};

int x = 5;
int y = 20;
int w = 50;
int h = 8;
int l = 2;
int spacing = 4;

void setupScrollbars() {
  for (int i = 0; i < hs.length; i++) {
    hs[i] = new HScrollbar(x, y + i*(h+spacing), w, h, l);
  }

  hs[0].setPos(0.5);
  hs[1].setPos(0.5);
  hs[2].setPos(0.5);
  hs[3].setPos(0.5);
  hs[4].setPos(0.05);

}

void drawScrollbars() {
  //if (showvalues) {
  swt = hs[0].getPos()*10.0f;     //sep.mult(25.0f);
  awt = hs[1].getPos()*2.0f;     //sep.mult(25.0f);
  cwt = hs[2].getPos()*2.0f;     //sep.mult(25.0f);
  maxspeed = hs[3].getPos()*10.0f;
  maxforce = hs[4].getPos()*0.5;


  if (showvalues) {
    for (int i = 0; i < hs.length; i++) {
      hs[i].update();
      hs[i].draw();
      fill(0);
      textAlign(LEFT);
      text(labels[i],x+w+spacing,y+i*(h+spacing)+spacing);
      //text(hs[i].getPos(),x+w+spacing+75,y+i*(h+spacing)+spacing);
    }
  }
}


class HScrollbar
{
  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if(over()) {
      over = true;
    } 
    else {
      over = false;
    }
    if(mousePressed && over) {
      scrollbar = true;
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
      scrollbar = false;
    }
    if(locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if(abs(newspos - spos) > 0) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } 
    else {
      return false;
    }
  }

  void draw() {
    fill(255);
    rectMode(CORNER);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(153, 102, 0);
    } 
    else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  void setPos(float s) {
    spos = xpos + s*(sposMax-sposMin);
    newspos = spos;
  }

  float getPos() {
    // convert spos to be values between
    // 0 and the total width of the scrollbar
    return ((spos-xpos))/(sposMax-sposMin);// * ratio;
  }
}





// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
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

float swt = 25.0;     //sep.mult(25.0f);
float awt = 4.0;      //ali.mult(4.0f);
float cwt = 5.0;      //coh.mult(5.0f);
float maxspeed = 1;
float maxforce = 0.025;


// Flocking
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2009

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {

  PVector pos;
  PVector vel;
  PVector acc;
  float r;

  Boid(float x, float y) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    pos = new PVector(x,y);
    r = 2.0;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(swt);
    ali.mult(awt);
    coh.mult(cwt);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    pos.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,pos);  // A vector pointing from the position to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (pos.x < -r) pos.x = width+r;
    if (pos.y < -r) pos.y = height+r;
    if (pos.x > width+r) pos.x = -r;
    if (pos.y > height+r) pos.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos,other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector steer = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50.0;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(pos,other.pos);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.pos); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the position
    }
    return sum;
  }
}

