////fails if rect of enemy is not mostly square.
////The rotation is for visual purposes.
////The collision is tied to the unrotated rect of the box not the rotated visual

Sprite s;
Enemy e;
Bullet b;

boolean left, right, up, down, space;

void setup() {
  size(800, 600);
  background(255);
  smooth();
  s = new Sprite();
  e = new Enemy();
  b = new Bullet();

  left = false;
  right = false;
  up = false;
  down = false;
  space = false;
  //frameRate(10);
}

void draw() {
  background(255);
  s.update();
  s.display();
  e.update(s);
  e.display();
  if (rectangleIntersect(s, e)) {
    fill(255, 0, 0, 100);
    rect(0, 0, width, height);
  }//end rect intersect
  if (space) {
    b.setStartLocation(s.x, s.y, s.rotation);
  }//end space
  b.update();
  b.display();

  if (rectangleIntersect(b, e)) {
    //kill the enemy
    fill(255, 255, 0, 100);
    rect(0, 0, width, height);
    // e.respawn();
    // b.reset();
  }
}// end draw

boolean rectangleIntersect(Sprite r1, Enemy r2) {
  //what is the distance apart on x-axis
  float distanceX = (r1.x) - (r2.x);
  //what is the distance apart on y-axis
  float distanceY = (r1.y) - (r2.y);


  //what is the combined half-widths
  float combinedHalfW = r1.w/2 + r2.w/2;
  //what is the combined half-heights
  float combinedHalfH = r1.h/2 + r2.h/2;

  //check for intersection on x-axis
  if (abs(distanceX) < combinedHalfW) {
    //check for intersection on y-axis
    if (abs(distanceY) < combinedHalfH) {
      //huzzah they are intersecting
      return true;
    }
  }
  return false;
}

boolean rectangleIntersect(Bullet r1, Enemy r2) {
  //what is the distance apart on x-axis
  float distanceX = (r1.x) - (r2.x);
  //what is the distance apart on y-axis
  float distanceY = (r1.y) - (r2.y);

  //what is the combined half-widths
  float combinedHalfW = r1.w/2 + r2.w/2;
  //what is the combined half-heights
  float combinedHalfH = r1.h/2 + r2.h/2;

  //check for intersection on x-axis
  if (abs(distanceX) < combinedHalfW) {
    //check for intersection on y-axis
    if (abs(distanceY) < combinedHalfH) {
      //huzzah they are intersecting
      return true;
    }
  }
  return false;
}

void keyPressed() {
  switch (keyCode) {
  case 37:
    left = true;
    break;
  case 38:
    up = true;
    break;
  case 39:
    right = true;
    break;
  case 40:
    down = true;
    break;
  case 32:
    space = true;
    break;
  }
}
void keyReleased() {
  switch (keyCode) {
  case 37:
    left = false;
    break;
  case 38:
    up = false;
    break;
  case 39:
    right = false;
    break;
  case 40:
    down = false;
    break;
  case 32:
    space = false;
    break;
  }
}



///////////
class Bullet {
  float x, y, w, h;
  float speed, rotation, maxSpeed, minSpeed;
  boolean firing;

  Bullet() {
    x = 100;
    y = -100;
    w = 20;
    h = 10;

    speed = 0;
    rotation = 0;
    maxSpeed = 15;
    minSpeed = 5;
    firing = false;
  }
  void setStartLocation(float startX, float startY, float startRotation) {
     if (firing == false) {
      x = startX;
      y = startY;
      rotation = startRotation;
      firing = true;
      speed = 20;
     }
  }
  void update() {
    if (firing == true) {
      //bullet speeds up
      //if (speed < maxSpeed) {
      //  speed += 2;
      //}
      //bullet slows down
      if (speed > minSpeed) {
        speed -= 0.3;
      }

      x += cos(rotation) * speed;
      y += sin(rotation) * speed;

      //check for moving out of bounds
      if (x>width||x<0||y>height||y<0) {
        reset();
      }
    }
  }
  void reset() {
    speed = 0;
    firing = false;
    y = -100;
  }
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    fill(0, 255, 0); 
    rect(-w/2, -h/2, w, h);
    popMatrix();
  }
}

/////////

class Enemy {
  float x, y, w, h;

  //float speedX, speedY;
  float speed, rotation, maxSpeed;

  Enemy() {
    x = 400;//random(400, width-100);
    y = 100;//random(100, height-100);
    w = 64;
    h = 64;

    speed = 0;
    rotation = 0;
    maxSpeed = 3;
  }
  void respawn(){
    x = random(400, width-100);
    y = random(100, height-100);
    speed = 0;
    rotation = 0;
  }
  void update(Sprite s) {
    //find the distance between enemy and sprite
    float distanceApart = dist(x, y, s.x, s.y);
    if (distanceApart < 300) {
      rotation = atan2((s.y - y), (s.x - x));
      //speed = 2;
      if (speed < maxSpeed){
        speed += 0.2;
      }
      
    } else {
      if (speed > 0){
        speed *= 0.95;
      }
    }
    x += cos(rotation) * speed;
    y += sin(rotation) * speed;
  }
  void display() {
    pushMatrix();
      translate(x,y);
      //draw transparent box that shows the bounds of the object
      fill(0,0,255,128); 
      rect(-w/2,-h/2,w,h);
      rotate(rotation);
      //draw visible artwork
      fill(0,255,0,128); 
      rect(-w/2,-h/2,w,h);
      fill(255,0,0);
      ellipse(w/2,0,10,10);
    popMatrix();
  }
}

///////

class Sprite {
  float x, y, w, h;

  //float speedX, speedY;
  float speed, rotation, maxSpeed;

  Sprite() {
    x = 100;
    y = 100;
    w = 64;
    h = 32;

    //speedX = 0;
    //speedY = 0;
    speed = 0;
    rotation = 0;
    maxSpeed = 1;
  }
  void update() {
    if (left){
      rotation -= radians(1);
    }
    if (right){
      rotation += radians(1);
    }
    if (up){
      speed = 5;
      // if (speed < maxSpeed){
      //   speed += 1;
      // }
    }
    if (down){
      speed = -5;
    }
    if (!up && !down){
      //speedY = 0;
      if (speed > 0 || speed < 0){
        speed *= 0.98; 
      }
    }else if (up && down){
       //speedY = 0; 
    }
    
    x += cos(rotation) * speed;
    y += sin(rotation) * speed;
    
    //asteroids sytyle screen wrap
    if (x > width){x = 0;}
    if (x < 0){ x = width;}
    if (y > height){y = 0;}
    if (y < 0){y = height;}
  }
  void display() {
    pushMatrix();
      translate(x,y);
      //draw transparent box that shows the bounds of the object
      fill(0,0,255,100);
      rect(-w/2,-h/2,w,h);
      rotate(rotation);
      //draw visible artwork
      fill(0,0,255); 
      rect(-w/2,-h/2,w,h);
      fill(255,0,0);
      ellipse(w/2,0,10,10);
    popMatrix();
  }
}
