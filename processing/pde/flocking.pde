ArrayList<Flocker> flock = new ArrayList<Flocker>();

void setup() {
  size(200, 200);
}

void draw() {

  background(200);

  for (Flocker f : flock) {
    f.step();
    f.draw();
  }
}

void mouseDragged() {
  flock.add(new Flocker(mouseX, mouseY));
}

class Flocker {

  float x;
  float y;
  float heading = random(TWO_PI);
  float speed = random(1, 3); 
  float radius = random(10, 20);

  public Flocker(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void step() {

    //we need more than one Flocker for this to work
    if (flock.size() > 1) {
      
      //find the closest Flocker
      float closestDistance = 100000;
      Flocker closestFlocker = null;
      for (Flocker f : flock) {

        //make sure not to check against yourself
        if (f != this) {
          float distance = dist(x, y, f.x, f.y);
          if (distance < closestDistance) {
            closestDistance = distance;
            closestFlocker = f;
          }
        }
      }

      float angleToClosest = atan2(closestFlocker.y-y, closestFlocker.x-x);

      //prevent case where heading is 350 and angleToClosest is 10
      if (heading-angleToClosest > PI) {
        angleToClosest += TWO_PI;
      } else if (angleToClosest-heading > PI) {
        angleToClosest -= TWO_PI;
      }

      //turn towards closest
      if (heading < angleToClosest) {
        heading+=PI/40;
      } else {
        heading-=PI/40;
      }

      //move in direction
      x += cos(heading)*speed;
      y += sin(heading)*speed;

      //wrap around edges
      if (x < 0) {
        x = width;
      }
      if (x > width) {
        x = 0;
      }

      if (y < 0) {
        y = height;
      }
      if (y > height) {
        y = 0;
      }
    }
  }

  void draw() {
    ellipse(x, y, radius, radius);
  }
}
