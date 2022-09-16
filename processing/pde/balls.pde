float goldenRatio = (1 + sqrt(5) / 2);
ArrayList<Ball> balls;
static final float BALL_SIZE = 14;
int counter = 0;

void setup() {
  size(800, 800);
  noStroke();

  balls = new ArrayList<Ball>();
  balls.add(new Ball(BALL_SIZE, 0));
}

void draw() {
  background(50);

  for (int i = balls.size() - 1; i >= 0; i--) {
    balls.get(i).shift(i, balls);
    balls.get(i).show(i);
    
    if(balls.get(i).hasGoneTooFar()) {
      balls.remove(i); 
    }
  }

  counter++;
  
  balls.add(new Ball(BALL_SIZE - (counter % 400)/40, counter * radians(137.5)));
  //balls.add(new Ball(BALL_SIZE - (counter % 400)/40, counter * goldenRatio * PI));
}

//////////////

class Ball {

  PVector worldCenter, ballPosition, direction;
  float size;

  Ball(float diam, float angle) {
    this.size = diam;

    worldCenter = new PVector(width / 2, height / 2);
    printlin(worldCenter.x);
    
    ballPosition = worldCenter.copy();
    printlin(worldCenter.x);
    printlin(ballPosition.x);
    direction = new PVector(cos(angle), sin(angle));
    
  }

  void show(int index) {
    fill(map(index, 0, 255, 250, 90), 255, 116, 255); //map(index, 0, 255, 20, 255)
    ellipse(ballPosition.x, ballPosition.y, size, size); //rect
  }

  void shift(int index, ArrayList<Ball> balls) {
    for (int i = index + 1; i < balls.size() -1; i++) {
      if (PVector.dist(ballPosition, balls.get(i).ballPosition) < 14) {
        ballPosition.add(direction);
      }
    }
  }

  boolean hasGoneTooFar() {
    if (PVector.dist(ballPosition, worldCenter) > width / 3) {
      return true;
    }
    return false;
  }
}
