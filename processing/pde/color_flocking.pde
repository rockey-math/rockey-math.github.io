int rectSize = 8;
int columns, rows;

Block[][] blocks;
ArrayList<Block> locBlocks;

Block west, east, north, south;
Block northwest, northeast, southwest, southeast;

void setup() {
  size(800, 800); 

  columns = width / rectSize;
  rows = height / rectSize;

  blocks = new Block[columns][rows];

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < columns; x++) {
      blocks[y][x] = new Block(x * rectSize, y * rectSize, rectSize);
    }
  }
  smooth();
}

void draw() {
  background(50);

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < columns; x++) {

      if (x > 0) west = blocks[y][x - 1];
      if (x < columns - 1) east = blocks[y][x + 1];
      if (y > 0) north = blocks[y - 1][x];
      if (y < rows - 1) south = blocks[y + 1][x];

      if ((x > 0) && (y > 0)) northwest = blocks[y - 1][x - 1];
      if ((x < columns - 1) && (y > 0)) northeast = blocks[y - 1][x + 1];
      if ((y < rows - 1) && (x > 0)) southwest = blocks[y + 1][x - 1];
      if ((y < rows - 1) && (x < columns - 1)) southeast = blocks[y + 1][x + 1];

      printlln(columns);
      printlln(rows);
      
      locBlocks = new ArrayList<Block>();

      locBlocks.add(west);
      locBlocks.add(east);
      locBlocks.add(north);
      locBlocks.add(south);
      locBlocks.add(northwest);
      locBlocks.add(northeast);
      locBlocks.add(southwest);
      locBlocks.add(southeast);

      blocks[y][x].flock(locBlocks);

      blocks[y][x].render();
      blocks[y][x].updatePosition();
    }
  }
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {      
        blocks[y][x].setGrayscaleColor();
      }
    }
  } else if (key == 'c' || key == 'C') {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        blocks[y][x].setRandomColor();
      }
    }
  }
}



////////////////
// float maxSpeed = 2.0;
// float maxForce = 0.02;

class Block {

  PVector position, velocity, acceleration, rgb;
  float radius, size, grayscale;
  
  float maxSpeed = 2.0;
  float maxForce = 0.02;

  Block(float x, float y, float s) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    rgb = new PVector(floor(random(256)), floor(random(256)), floor(random(256)));
    //grayscale = floor(random(255));
    //rgb = new PVector(grayscale, grayscale, grayscale);
    size = s;
  }

  void run(ArrayList<Block> blocks) {
    flock(blocks);
    updatePosition();
    screenEdge();
    render();
  }

  void updatePosition() {
    // update velocity & set limit
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    rgb.add(velocity);

    screenEdge();

    // reset acceleration to 0 after each cycle
    acceleration.mult(0);
  }

  void render() {
    noStroke();
    fill(rgb.x, rgb.y, rgb.z);
    rect(position.x, position.y, size, size);
  }

  void flock(ArrayList<Block> blocks) {
    PVector alignment = align(blocks);
    PVector separation = separate(blocks);
    PVector cohesiveness = cohesion(blocks);

    alignment.mult(1.5);
    separation.mult(1.5);
    cohesiveness.mult(2.0);

    applyForce(alignment);
    applyForce(separation);
    applyForce(cohesiveness);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, rgb);

    desired.normalize();
    desired.mult(maxSpeed);

    //Steering = Desired - Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }

  PVector separate(ArrayList<Block> blocks) {
    //float separationDist = 20.0;
    PVector sum = new PVector(0, 0, 0);
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Block neighbor : blocks) {
      if (neighbor != null) {
        //float distance = PVector.dist(rgb, neighbor.rgb);
        //if ((distance > 0) && (distance < separationDist)) {
        //if (distance > 0) {
          PVector difference = PVector.sub(rgb, neighbor.rgb);
          difference.normalize();
          //difference.div(distance);
          sum.add(difference);
          count++;
        }
      //}
    }

    if (count > 0) {
      sum.div((float) count);
      sum.normalize();
      sum.mult(maxSpeed);

      steer = sum.sub(velocity);
      steer.limit(maxForce);
    }

    return steer;
  }


  PVector align(ArrayList<Block> blocks) {
    //float neighborDist = 25.0;
    PVector steer = new PVector();
    PVector sum = new PVector(0, 0, 0);
    int count = 0;

    for (Block neighbor : blocks) {
      if (neighbor != null) {
        //float d = PVector.dist(rgb, neighbor.rgb);
        //if ((d > 0) && (d < neighborDist)) {
        //if (d > 0) {
          sum.add(neighbor.velocity);
          count++;
        //}
      }
    }

    if (count > 0) {
      sum.div((float)count);
      // Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxSpeed);

      steer = sum.sub(velocity);
      steer.limit(maxForce);
    }

    return steer;
  }

  PVector cohesion(ArrayList<Block> blocks) {
    //float neighborDist = 40.0;
    PVector sum = new PVector(0, 0, 0);
    int count = 0;

    for (Block neighbor : blocks) {
      if (neighbor != null) {
        //float d = PVector.dist(rgb, neighbor.rgb);
        ////if ((d > 0) && (d < neighborDist)) {
        //if (d > 0) {
          sum.add(neighbor.rgb);
          count++;
        //}
      }
    }

    if (count > 0) {
      sum.div((float) count);
      return seek(sum);
    }

    return sum;
  }

  void setRandomColor() {
    rgb.set(floor(random(256)), floor(random(256)), floor(random(256)));
  }
  
  void setGrayscaleColor() {
    grayscale = floor(random(255));
    rgb.set(grayscale, grayscale, grayscale);
  }

  void screenEdge() {
    if (rgb.x > 255) {
      rgb.x = 255;
      velocity.x *= -1;
    } else if (rgb.x < 0) {
      rgb.x = 0;
      velocity.x *= -1;
    }

    if (rgb.y > 255) {
      rgb.y = 255;
      velocity.y *= -1;
    } else if (rgb.y < 0) {
      rgb.y = 0;
      velocity.y *= -1;
    }

    if (rgb.z > 255) {
      rgb.z = 255;
      velocity.z *= -1;
    } else if (rgb.z < 0) {
      rgb.z = 0;
      velocity.z *= -1;
    }
  }
}
