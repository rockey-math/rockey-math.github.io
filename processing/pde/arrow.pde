//drawArrow (grillgemuese)
final int arrowSize = 50; //lenght in pixels

float arrowAngle = 0.0;

void setup()
{
  size(300, 300);
  frameRate(30);
  surface.setTitle("arrow Demo");
}//void setup() END

void draw()
{
  background(#EAEAEA); //clear old drawings
  //helplines X
  stroke(#06D3C7);
  line(0, 0, width, height);
  line(0, height, width, 0);
  
  fill(#DB0202); //RED
  //example: arrow(arrowHeadX, arrowHeadY, arrowSize, arrowAngle);
  arrow(width/2, height/2, arrowSize, arrowAngle);
  
  if (arrowAngle >= 360.0) arrowAngle = 0.0;
  else arrowAngle += 1.0;
}//void draw() END

void arrow(final int aHeadX, final int aHeadY, final int aSize, final float aAngle)
{
  final float thFac = 10.0;  //thickness factor (org.:10.0)
  float sizeFac = float(aSize) / thFac;
  pushMatrix(); //make translate independent to main surface
    translate(float(aHeadX), float(aHeadY)); //recenter (x0,y0)
    rotate(radians(aAngle));
    noStroke(); //disable border of rect
    rect(0.0-sizeFac/2.0, sizeFac/2.0, sizeFac, float(aSize)); //center
    pushMatrix(); //make rotate independent to other lines
      rotate(radians(-45.0));
      rect(0.0-sizeFac, 0.0, sizeFac, float(aSize)/2.0); //right
    popMatrix();
    pushMatrix();
      rotate(radians(45.0));
      rect(0.0, 0.0, sizeFac, float(aSize)/2.0); //left
    popMatrix();
  popMatrix();
}//void arrow(.) END
