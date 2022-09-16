Drop[] drops = new Drop[40];
Cloud[] clouds = new Cloud[100];
Sun sun = new Sun(50);

void setup() {
  size(1000, 1000);
  for (int i = 0; i < drops.length; i++) {
    drops[i] = new Drop();  
  }
  
  for (int i = 0; i < clouds.length; i++) {
    clouds[i] = new Cloud();
  }
  
}

void draw() {
  background(50);
  
  //sun.show();
  //sun.pulse();

  for (int i = 0; i < drops.length; i++) {
    drops[i].fall();
    drops[i].show();
  }
  
  for (int i = 0; i < clouds.length; i++) {
    clouds[i].show();
    clouds[i].fade();
  }
  
}

//////////

class Cloud {
  float cloudBoundWidth = 120;
  float cloudBoundHeight = 80;
  float x = (width / 2) - (cloudBoundWidth / 2);
  float y = height / 7;
  
  float cloudX, cloudY, cloudWidth, cloudHeight;
  
  Cloud() {
    cloudReset();
  }
  
  void fade() {
    cloudWidth = cloudWidth - random(1);
    cloudHeight = cloudHeight - random(1);
    cloudX = cloudX + random(1);
    cloudY = cloudY + random(1);
    
    if (cloudWidth < 0 || cloudHeight < 0) {
      cloudReset();
    }

  }
  
  void show() {
    fill(250, 200);
    noStroke();
    rect(cloudX, cloudY, cloudWidth, cloudHeight);
  }
  
  void cloudReset() {
    cloudX = random(x - cloudBoundWidth / 2, x + cloudBoundWidth / 2);
    cloudY = random(y, y + cloudBoundHeight);
    cloudWidth = random(cloudBoundWidth / 4, cloudBoundWidth);
    cloudHeight = random(cloudBoundHeight / 4, cloudBoundHeight);    
  }
}

/////////////

class Drop {
 float cloudWidth = 100;
 float cloudHeight = 75;
 
 float x = random(width / 2 - cloudWidth / 2, width / 2 + cloudWidth / 2);
 float y = random(height / 5, height * .85);
 float z = random(0, 20);
 float len = map(z, 0, 20, 10, 20);
 float ySpeed = map(z, 0, 20, 4, 8);
 
 Splash splash = new Splash();
 
 void fall() {
   y = y + ySpeed;
   ySpeed = ySpeed + 0.05;
   
   if (y > height * .85) {
     splash.show(x, y);
     splash.splashes();
     rainReset();
   }
 }
 
 void show() {
   float thinkness = map(z, 0, 20, 1, 3);
   strokeWeight(thinkness);
   stroke(200);
   line(x, y, x, y+len);
 }
 
 void rainReset() {
   y = random(height / 5, height / 3 + cloudHeight);
   ySpeed = map(z, 0, 20, 4, 8);
 }
 
}


/////////////

class Splash {
  
  float x, y;
  float radius = 10;
  float speed = 5;
  
  
  void splashes() {
    radius += 3;
  }
 
  void show(float x, float y) {
    fill(250, 0);
    stroke(250);
    ellipse(x, y, radius, 3);
  }
  
}

//////////////

class Sun {
 
  float x;
  float y;
  float radius;
  float expandRate = 1;
  
  Sun(float radius) {
    this.radius = radius;
  }
  
  void pulse() {
    if (radius < 150) {
      fill(255, 220, 0, 255 - (expandRate * 10));
      radius = radius + expandRate;
    } else {
      radius = 100; 
    }
    
  }
  
  void show() {
    fill(255, 220, 0, 255);
    ellipse(width / 2, height / 5, radius * 2, radius * 2);
  }
  
}

