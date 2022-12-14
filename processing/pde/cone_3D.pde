    int rotation1 = 0;
    int rotation2 = 0;
    int rotation3 = 0;
    int rotation4 = 0;
    int type = 1;
    
    PVector[][] globe;
    int total = 75;
    float radiusSphere = 200.0;
    float r2 = 100.0;
    float r3 = 40.0;
    float lengthArrow = 200.0;

    void setup() {
      size(600,600,P3D);
      // background(0);
      
      globe = new PVector[total+1][total+1];
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
       arrow3D(10.0, 0, lengthArrow, 6);
       // rotation1 = (rotation1 + 0.5);
      popMatrix();  
      
      pushMatrix();
       // noStroke();
       // fill(205, 230, 255, 200);
       // lights();
       noFill();
       stroke(255);
       // translate(50, height*0.35, -200);
       // translate(0, 0, -50);
       rotateY(rotation2 * (PI/180));
       rotateX(rotation2 * (PI/180));
       // rotateX(90.0 * (PI/180));
       // rotateZ(rotation2 * (PI/180));
       // sphere(100.0);
       drawSphere(type, radiusSphere, total)
       // rotation2 = (rotation2 + 0.1);
      popMatrix();
      
      v1 = new PVector(0, radiusSphere, 0);
      
      pushMatrix();
       // noStroke();
       // fill(255,255,255);
       strokeWeight(10);
       
       rotateY(rotation3 * (PI/180));
       rotateZ(rotation3 * (PI/180));
       
       beginShape(POINTS);
         vertex(v1.x,v1.y,v1.z);
       endShape();
       
       translate(v1.x,v1.y,v1.z);
          //pushMatrix();  // 이런 식으로 작동 안하는듯. 아래 로테이션이 무시되어버린듯.
              //rotateY(rotation4 * (PI/180));
              drawSphere(3, r2, total);
              arrow3D(5.0, 0, r2, 6); // arrow3D(5.0, 0, r2, 6, n.x, n.y, n.z, theta, speed);  로테이션/로테이션속도도 서브루틴안에 들어가야 하나?
          //popMatrix();
       //println(v1.x, v1.y, v1.z);
      popMatrix();
      
      /*
      // v2 = new PVector(0, radiusSphere + r2 , 0);
      v2 = new PVector(0, r2 , 0);
      
      pushMatrix();
       // noStroke();
       // fill(255,255,255);
       strokeWeight(10);
       
       translate(v1.x,v1.y,v1.z);
       rotateY(rotation3 * (PI/180));
       rotateZ(rotation3 * (PI/180));
       
       translate(v2.x,v2.y,v2.z);
       rotateY(rotation4 * (PI/180));
       rotateZ(rotation4 * (PI/180));
       
       beginShape(POINTS);
         vertex(v2.x,v2.y,v2.z);
       endShape();
       
       // translate(v2.x,v2.y,v2.z);
       
       drawSphere(3, r3, total);
       arrow3D(5.0, 0, r3, 6); // arrow3D(5.0, 0, r2, 6, n.x, n.y, n.z, theta, speed);  로테이션/로테이션속도도 서브루틴안에 들어가야 하나?
       
       // println(v1);
      popMatrix();
      */
      
      rotation1 = (rotation1 + 0.5);
      rotation2 = (rotation2 + 0.1);
      rotation3 = (rotation3 + 0.5);
      rotation4 = (rotation4 + 0.7);
    }
  
//////////////////////////////////////////////////////////////     
void drawSphere(type, radiusSphere, total) 
{
 float r = radiusSphere;
 
 pushMatrix();
 
 if (type == 1) { // fibonacci sphere
    
    noStroke();
    fill(30., 85., 150., 150.);
    lights();   // 라이츠가 없으면 오패시티가 작동안하는거 같다. 
    sphere(r);
      
    noFill();
    stroke(255,255,0);
    strokeWeight(5);
    
    int numPoints = 4 * total;
    
    float goldenRatio = ( 1 + sqrt(5) )/2;
    float angleIncrement = TAU * goldenRatio; 
   
    for (int i=0; i < numPoints + 1; i++) {
      // float t = (float) i/numPoints;
      float t = i/numPoints;
      float angle1 = acos(1-2*t);
      float angle2 = angleIncrement * i;
      
      float x = r * sin(angle1) * cos(angle2);
      float y = r * sin(angle1) * sin(angle2);
      float z = r * cos(angle1); 
      // PVector pointOnSphere = new PVector(x,y,z);
      globe[0][i] = new PVector(x, y, z);
    }  // for
    
    // float hu = map(i, 0, total, 0, 255*6);
    // fill(hu  % 255, 255, 255);
    // beginShape(TRIANGLE_STRIP); 
    beginShape(POINTS);
    
    // beginShape(LINES);
    for (int i = 0; i < numPoints ; i++) {
      PVector v1 = globe[0][i];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[0][i+1];
      vertex(v2.x, v2.y, v2.z);
      
    }
    endShape();
  
 
} else if (type == 2) { // u,v sphere
 
    noFill();
    stroke(255);
    
    int numHorizontalSegments = total;
    int numVerticalSegments = total;
    // for (int h=0; h < numHorizontalSegments; h++) {
    for (int h=0; h < numHorizontalSegments + 1; h++) {
        float angle1 = (h+1) * PI / (numHorizontalSegments + 1); 
        //for (int v=0; v <= numVerticalSegments; v++) {
        for (int v=0; v < numVerticalSegments + 1; v++) {
            float angle2 = v * TAU / numVerticalSegments; 
            float x = r * sin(angle1) * cos(angle2);
            float z = r * sin(angle1) * sin(angle2);
            float y = r * cos(angle1); 
            // PVector pointOnSphere = new PVector(x,y,z);
            globe[h][v] = new PVector(x, y, z);
        } // for
     } // for   
     
    for (int h=0; h < numHorizontalSegments; h++) {
     // float hu = map(i, 0, total, 0, 255*6);
     // fill(hu  % 255, 255, 255);
     // beginShape(TRIANGLE_STRIP);
     // beginShape(POINTS);
     beginShape(LINES);
     // for (int v=0; v <= numVerticalSegments; v++) {
     for (int v=0; v < numVerticalSegments + 1; v++) {
       PVector v1 = globe[h][v];
       vertex(v1.x, v1.y, v1.z);
       PVector v2 = globe[h+1][v];
       vertex(v2.x, v2.y, v2.z);
     }
     endShape();
  }
  
 } else { // lat, long
 
  noFill();
  stroke(255);
  lights();
  
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, 0, PI);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, 0, TWO_PI);
      float x = r * sin(lat) * cos(lon);
      float y = r * sin(lat) * sin(lon);
      float z = r * cos(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }

  for (int i = 0; i < total; i++) {
    // float hu = map(i, 0, total, 0, 255*6);
    // fill(hu  % 255, 255, 255);
    // beginShape(TRIANGLE_STRIP);
    // beginShape(POINTS);
    beginShape(LINES);
    for (int j = 0; j < total+1; j++) {
      
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
 } // end if 
 popMatrix();
} // void drawSphere(
     
  //////////////////////////////////////////////////////////////////////////   
    void arrow3D(float bottom, float top, float h, int sides)
    {
      PVector head = new PVector(0, h, 0);
      // println(head);
      
      pushMatrix();
      
        float lhead = h/10;
        float lbody = h/10*9;
        
        // translate(0,lbody/2,0);
        // translate(0,-lbody,0);
        translate(0,h/2,0);
        // rotateX(millis() * 0.0001);//animation
      
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
