    int rotation1 = 0;
    int rotation2 = 0;
    
    
    void setup() {
      size(600,600,P3D);
      // background(0);
    }
    
    void draw() {
      background(0);
      translate(width/2, height/2);
      // println(mouseX);
      // println(mouseY);
      
      // rotateZ(-3*PI/4); // 오른쪽 핸디드가 아니라 모니터방향을 따르다보니 이상해짐. 반대로 됨. 
      // rotateX(PI/4);
      // arrow3D(10.0, 0, 100.0, 6); // 헤드 바텀  직경, 헤드 탑 직경, 몸통은 헤드 바텀 직경의 절반, 몸통 길이, 실린더 다각형 꼭지점수 
      
      
      pushMatrix();
       noStroke();
       fill(255,255,255);
       // lights();
       // translate(130, height/2, 0);
       rotateY(rotation1 * (PI/180));
       // rotateX(rotation1 * (PI/180));
       rotateZ(rotation1 * (PI/180));
       arrow3D(10.0, 0, 100.0, 6);
       rotation1 = (rotation1 + 1);
      popMatrix();  
      
      pushMatrix();
       // noStroke();
       // fill(205, 230, 255, 200);
       // lights();
       noFill();
       stroke(255);
       // translate(50, height*0.35, -200);
       // translate(0, 0, -50);
       // rotateY(rotation2 * (PI/180));
       // rotateX(rotation2 * (PI/180));
       rotateX(90.0 * (PI/180));
       // rotateZ(rotation2 * (PI/180));
       sphere(100.0);
       // rotation2 = (rotation2 + 0.1);
      popMatrix();
  
      
    }
    
    
    
    // fibonacci sphere
    float goldenRatio = ( 1 + sqrt(5) )/2;
    float angleIncrement = TAU * goldenRatio; 
    
    for (int i=0; i < numPoints; i++) {
      float t = (float) i/numPoints;
      float angle1 = acos(1-2*t);
      float angle2 = angleIncrement * i;
      
      float x = sin(angle1) * cos(angle2);
      float x = sin(angle1) * sin(angle2);
      float z = cos(angle1); 
      PVector pointOnSphere = new PVector(x,y,z);
    }  




     
    void arrow3D(float bottom, float top, float h, int sides)
    {
      pushMatrix();
      
        float lhead = h/10;
        float lbody = h/10*9;
        
        translate(0,lbody/2,0);
        // translate(0,-lbody,0);
        
      
        float angle;
        float[] x = new float[sides+1];
        float[] z = new float[sides+1]; 
        float[] x2 = new float[sides+1];
        float[] z2 = new float[sides+1];
        
        float[] x3 = new float[sides+1];
        float[] z3 = new float[sides+1];
        
        //////////////////////////////////////////////
        //get the x and z position on a circle for all the sides
        for(int i=0; i < x3.length; i++){
          angle = TWO_PI / (sides) * i;
          x3[i] = sin(angle) * bottom/2;
          z3[i] = cos(angle) * bottom/2;
        }
        //draw the bottom of the cylinder
        beginShape(TRIANGLE_FAN); 
          vertex(0,   -lbody/2,    0);    
          for(int i=0; i < x3.length; i++){
            vertex(x3[i], -lbody/2, z3[i]);
          }    
        endShape();
        //draw the center of the cylinder
        beginShape(QUAD_STRIP);    
          for(int i=0; i < x3.length; i++){
            vertex(x3[i], -lbody/2, z3[i]);
            vertex(x3[i], lbody/2, z3[i]);
          }    
        endShape();
        //draw the top of the cylinder
        beginShape(TRIANGLE_FAN);   
          vertex(0,   lbody/2,    0);    
          for(int i=0; i < x3.length; i++){
            vertex(x3[i], lbody/2, z3[i]);
          }
        endShape();
        ///////////////////////////
     
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
          vertex(0,   (lbody-lhead)/2,    0);    
          for(int i=0; i < x.length; i++){
            vertex(x[i], (lbody-lhead)/2, z[i]);
          }    
        endShape();
        //draw the center of the cylinder
        beginShape(QUAD_STRIP);    
          for(int i=0; i < x.length; i++){
            vertex(x[i], (lbody-lhead)/2, z[i]);
            vertex(x2[i], (lbody+lhead)/2, z2[i]);
          }    
        endShape();
        //draw the top of the cylinder
        beginShape(TRIANGLE_FAN);   
          vertex(0,   (lbody+lhead)/2,    0);    
          for(int i=0; i < x.length; i++){
            vertex(x2[i], (lbody+lhead)/2, z2[i]);
          }
        endShape();
        
      popMatrix();
    }
