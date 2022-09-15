    void setup() {
      size(600,600,P3D);
      background(0);
    }
    
    void draw() {
      translate(200,200, 0);
      cylinder(100.0, 30.0,250.0, 6);
    }
    
    
    /**
    cylinder taken from http://wiki.processing.org/index.php/Cylinder
    @author matt ditton
    @modified by Abbas Noureddine, to draw a cone with specified width, dimeter of both
    top and bottom. (if top == bottom, then you have a cylinder)
    plus added a translation to draw the cone at the center of the bottom side
    */
     
    void cylinder(float bottom, float top, float h, int sides)
    {
      pushMatrix();
      
      translate(0,h/2,0);
      
      float angle;
      float[] x = new float[sides+1];
      float[] z = new float[sides+1];
      
      float[] x2 = new float[sides+1];
      float[] z2 = new float[sides+1];
     
      //get the x and z position on a circle for all the sides
      for(int i=0; i < x.length; i++){
        angle = TWO_PI / (sides) * i;
        x[i] = sin(angle) * bottom;
        z[i] = cos(angle) * bottom;
      }
      
      for(int i=0; i < x.length; i++){
        angle = TWO_PI / (sides) * i;
        x2[i] = sin(angle) * top;
        z2[i] = cos(angle) * top;
      }
     
      //draw the bottom of the cylinder
      beginShape(TRIANGLE_FAN);
     
      vertex(0,   -h/2,    0);
     
      for(int i=0; i < x.length; i++){
        vertex(x[i], -h/2, z[i]);
      }
     
      endShape();
     
      //draw the center of the cylinder
      beginShape(QUAD_STRIP); 
     
      for(int i=0; i < x.length; i++){
        vertex(x[i], -h/2, z[i]);
        vertex(x2[i], h/2, z2[i]);
      }
     
      endShape();
     
      //draw the top of the cylinder
      beginShape(TRIANGLE_FAN); 
     
      vertex(0,   h/2,    0);
     
      for(int i=0; i < x.length; i++){
        vertex(x2[i], h/2, z2[i]);
      }
     
      endShape();
      
      popMatrix();
    }
