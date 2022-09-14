// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

// Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

// Flowfield object
FlowField flowfield;
PShape arrow;
PImage a;

void setup() {
  size(1800, 540);
  // Make a new flow field with "resolution" of 16
  flowfield = new FlowField(60);
  arrow = loadShape("./pde/data/arrow.svg");
  a = loadImage("./pde/data/arrow60.png");
}

void draw() {
  background(255);
  // Display the flowfield in "debug" mode
  translate(30,30);
  flowfield.display();
  saveFrame("./pde/data/ch6_exc6.png");
  noLoop();
}
// Make a new flowfield
void mousePressed() {
  flowfield.init();
}


// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    init();
  }

  void init() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        //float theta = random(TWO_PI);
        //float theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
        float x = i*resolution;
        float y = j*resolution;
        PVector v = new PVector(width/2-x,-y);
        v.normalize();
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = v;// new PVector(cos(theta),sin(theta));
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }

  // Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        //drawVector(field[i][j],i*resolution,j*resolution,resolution-2);
        pushMatrix();
        //translate(i*resolution+arrow.width/2,j*resolution+arrow.height/2);
        translate(i*resolution,j*resolution);
        rotate(field[i][j].heading2D());
        imageMode(CENTER);
        //scale(0.2);
        image(a,0,0);
        //shape(arrow,-arrow.width/2,-arrow.height/2);
        //ellipse(0,0,8,8);
        popMatrix();
      }
    }

  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to position to render vector
    translate(x,y);
    stroke(0,100);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }


}





// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flow Field Following

class Vehicle {

  // The usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Vehicle(PVector l, float ms, float mf) {
    position = l.get();
    r = 3.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(position);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
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

  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x,position.y);
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
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
}


