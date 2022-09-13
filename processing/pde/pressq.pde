// https://stackoverflow.com/questions/26318719/how-to-create-a-new-instance-of-a-class-in-processing
ArrayList<Place> turret = new ArrayList<Place>();

void setup()
{ 
  size(1501, 811);
  background(255);
}
void draw()
{
  //if the list is not empty
  if (turret.size() > 0) {
    //it could be a regular for loop also
    for (Place p : turret) {
      p.circle();
      p.keyHandle();
    }
  }
}


void keyPressed(){
  // you can add as much Places as you want :)
  if(key == 'q'){
    turret.add(new Place(int(random(width)), int(random(height))));
  }
}

class Place
{ 
  int xPos, yPos;
  Place(int x, int y)
  {
    xPos = x;
    yPos = y;
  }

  void circle()
  {
    ellipse(xPos, yPos, 30, 30);
  }

  void move(int amount, char xy)
  {
    frameRate(10);
    pushMatrix();
    translate(xPos, yPos);
    if (xy == 'x')
      xPos+=amount;
    if (xy == 'y')
      yPos+=amount;
    circle();
    popMatrix();
  }

  int v=0;
  // you don't want to override processing keyPressed
  // unles you register it, so I'm changing the name
  void keyHandle()
  {
    if (keyPressed)
    {
      if (key == 'd' && v==0)
        move(30, 'x');
      if (key == 'a' && v==0)
        move(-30, 'x');
      if (key == 's' && v==0)
        move(30, 'y');
      if (key == 'w' && v==0)
        move(-30, 'y');
      if (key == 'x' && v==0)
      {
        v=1;
        fill(0);
      }
    }
  }
}
