    // https://forum.processing.org/one/topic/rotate-3d-around-it-s-center
    // 4 ellipses; over their edges are drawn lines (rects) at every angle.
    // Each rect is a PShape. See Naum Gabo.
    //
    //
    float CameraX; // both set in setup()
    float CameraY;
    float angle;
    //
    int max =361;
    // the ellipses
    PVector [] ellOuter  = new PVector [ max ];
    PVector [] ellInner  = new PVector [ max ];
    PVector [] ellMiddleInTheFront = new PVector [ max ];
    PVector [] ellMiddleInTheBack  = new PVector [ max ];
    // the shapes
    PShape  [] s      = new PShape  [ max ];  // http://www.processing.org/reference/createShape_.html
    PShape  s0        = new PShape (); 
    PShape  s1        = new PShape ();
    PShape  s2        = new PShape (); 
    PShape  s3        = new PShape ();
    //
    void setup()
    {
      size( 800, 800, P3D );
      //  pg = createGraphics(width, height);
      CameraX = width / 2.0;
      CameraY = 320;
      //  noCursor();
      int count = 0;
      for (int i=0; i<=360; i+=3) {
        float x = 193*sin(radians(i));
        float y = 320 + 133*cos(radians(i));   
        ellOuter[ count ] = new PVector(x, y, 0);
        //
        x = 40+56*sin(radians(i));
        y = 320 + 56*cos(radians(i)); 
        ellInner[ count ] = new PVector(x, y, 10);
        //
        x = 126*sin(radians(i));
        y = 320 + 86*cos(radians(i)); 
        ellMiddleInTheFront[ count ] = new PVector(x, y, 55);
        //
        x = 126*sin(radians(i));
        y = 320 + 86*cos(radians(i)); 
        ellMiddleInTheBack[ count ] = new PVector(x, y, -35);
        //
        // Creating the PShape
        s[count] = createShape();
        s[count].noFill();
        s[count].stroke(255);
        //
        s[count].vertex( ellOuter[ count ].x, ellOuter[ count ].y, ellOuter[ count ].z );
        s[count].vertex( ellMiddleInTheFront[ count ].x, ellMiddleInTheFront[ count ].y, ellMiddleInTheFront[ count ].z );
        s[count].vertex( ellInner[ count ].x, ellInner[ count ].y, ellInner[ count ].z );
        s[count].vertex( ellMiddleInTheBack[ count ].x, ellMiddleInTheBack[ count ].y, ellMiddleInTheBack[ count ].z );
        s[count].vertex( ellOuter[ count ].x, ellOuter[ count ].y, ellOuter[ count ].z );
        //
        s[count].end();
        //
        count++;
      } //
      println (count);
      max=count-1;
      s0=makeAWallFromTwoArrays(ellOuter, ellMiddleInTheFront);
      s1=makeAWallFromTwoArrays(ellMiddleInTheFront, ellInner);
      s2=makeAWallFromTwoArrays(ellInner, ellMiddleInTheBack);
      s3=makeAWallFromTwoArrays(ellMiddleInTheBack, ellOuter);
      //
    } // setup
    void draw()
    {
      background(0);
      lights();
      // camera
      camera( CameraX, CameraY, 700,
      width/2.0, 320, 0,
      0, 1, 0);
      //
      translate(width/2, 0);
      rotateY(radians(angle));
      //  for (int i=0; i<max; i+=1) {
      //    shape(s[i], 0, 0);
      //  } // for 
      //
      shape(s0, 0, 0);
      shape(s1, 0, 0);
      shape(s2, 0, 0);
      shape(s3, 0, 0);
      //
      angle+=.3;
      println (frameRate);
    } // draw
    void keyPressed() {
      if (key == CODED) {
        //
        if (keyCode == UP) {
          CameraY-=10;
          // println("UP");
        }
        else if (keyCode == DOWN) {
          CameraY+=10;
        }
        else if (keyCode == RIGHT) {
          CameraX+=10;
        }
        else if (keyCode == LEFT) {
          CameraX-=10;
        }
        else {
          // nothing
        }
      }
      else { 
        // not key == CODED
        //
      }
    }
    //
    PShape makeAWallFromTwoArrays(  PVector [] arr1, PVector [] arr2 ) {
      // receives a ceiling and a floor line and makes a wall as a PShape.
      PShape s1 = new PShape (); 
      //
      s1 = createShape(QUADS);
      //
      for (int i=0; i<=max-1; i+=1) {
        //
        s1.noStroke();
        s1.vertex(arr1[i].x, arr1[i].y, arr1[i].z);
        s1.vertex(arr2[i].x, arr2[i].y, arr2[i].z);
        s1.vertex(arr2[i+1].x, arr2[i+1].y, arr2[i+1].z);
        s1.vertex(arr1[i+1].x, arr1[i+1].y, arr1[i+1].z);
        //
      }
      //
      s1.end();
      return s1;
      //
    }
    //
