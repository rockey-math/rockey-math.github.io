
    Arrow arrow;
    Arrow another;
    
    void setup() {
      size(400,400,P3D);
      arrow = new Arrow(80,55,10,175,65,45);
      another = new Arrow(90,100,10,175,150,200);
    }
    
    void draw() {
      arrow.drawarrow();
      another.drawarrow();
    }
    
    class Arrow {
      float cc_x1, cc_y1, cc_z1, cc_x2, cc_y2, cc_z2;
     
      Arrow (float x1, float y1,float z1, float x2, float y2,float z2) {
        cc_x1 = x1;
        cc_y1 = y1;
        cc_z1 = z1;
        cc_x2 = x2;
        cc_y2 = y2;
        cc_z2 = z2;
      }
     
      void drawarrow() {
       stroke(0,0,0);
       line(cc_x1,cc_y1,cc_z1,cc_x2,cc_y2,cc_z2);
      
      pushMatrix();
     
        translate(cc_x2, cc_y2);
        float a = atan2(cc_x1-cc_x2, cc_y2-cc_y1);
        stroke(173,139,255);
        rotate(a);  
        line(0, 0,cc_z1, -0.25, -0.25,cc_z2);
        line(0, 0,cc_z1, 0.25, -0.25,cc_z2);
        popMatrix();
      }
    }
