// https://forum.processing.org/one/topic/pvector-rotation.html
PVector a ; 
PVector b ; 
PVector c = new PVector(0, 0, 0) ;
PVector bP, n1 ;
float nn;


PVector p = new PVector( random(0, 300), random(0, 300), random(0, 300) );
PVector q = new PVector( random(0, 300), random(0, 300), random(0, 300) ) ;
PVector r = new PVector( random(0, 300), random(0, 300), random(0, 300) ) ;

PVector n ; 
PVector g ;
PVector temp_n ; 

float ang = 0.8 ;

float l_ab, l_bc, l_ac; 
float d = 0 ; 
boolean map = false;


void setup()
{
  size( 700, 700, P3D);

  g = new PVector( (p.x+q.x+r.x)/3, (p.y+q.y+r.y)/3, (p.z+q.z+r.z)/3 ) ;
  l_ac = PVector.dist( p, r ); 
  l_bc = PVector.dist( q, r ) ; 
  l_ab = PVector.dist( p, q ) ; 

  PVector temp_a = PVector.sub( g, p ); 
  temp_a.normalize(); 
  temp_a.mult(d) ; 
  temp_a.add(p); 
  a = temp_a.get(); // pvector "a" from origin

  PVector temp_b = PVector.sub( q, p ) ; 
  temp_b.normalize(); 
  temp_b.mult(l_ab) ; 
  temp_b.add( a ) ; 
  b = temp_b.get() ; // pvector "b" from origin

  PVector nTemp= PVector.sub(q, a).cross(PVector.sub(r, a));
  nTemp.normalize() ;
  n = nTemp.get(); // normal to the triangular plane
  
  c.x=  (a.x*((n.y*n.y)+(n.z*n.z)) - (n.x*((a.y*n.y)+(a.z*n.z)-(n.x*b.x)-(n.y*b.y)-(n.z*b.z))))*(1-cos(ang)) + (b.x*cos(ang)) + ((-(a.z*n.y)+(a.y*n.z)-(n.z*b.y)+(n.y*b.z))*sin(ang)) ;
  c.y=  (a.y*((n.x*n.x)+(n.z*n.z)) - (n.y*((a.x*n.x)+(a.z*n.z)-(n.x*b.x)-(n.y*b.y)-(n.z*b.z))))*(1-cos(ang)) + (b.y*cos(ang)) + (( (a.z*n.x)-(a.x*n.z)+(n.z*b.x)-(n.x*b.z))*sin(ang)) ;
  c.z=  (a.z*((n.x*n.x)+(n.y*n.y)) - (n.z*((a.x*n.x)+(a.y*n.z)-(n.x*b.x)-(n.y*b.y)-(n.z*b.z))))*(1-cos(ang)) + (b.z*cos(ang)) + ((-(a.y*n.x)+(a.x*n.y)-(n.y*b.x)+(n.x*b.y))*sin(ang)) ;
 
  temp_n = n ; 
  temp_n.mult(30); // for the normal to be seen
  temp_n.add(p); // to draw the normal line
}


void draw()
{
  background( 204 ) ; 
  navigate(); 
  firstTriangle();
  if ( map) // presss any key
  {
    mappedTriangle();
  }
}


void firstTriangle()
{
  stroke( 255, 0, 0 ); 
  line( p.x, p.y, p.z, q.x, q.y, q.z ) ; 
  line( q.x, q.y, q.z, r.x, r.y, r.z ); 
  line( r.x, r.y, r.z, p.x, p.y, p.z ); 
  stroke( 120 );
  line(  p.x, p.y, p.z, temp_n.x, temp_n.y, temp_n.z ); 
  strokeWeight(1); 
  point( g.x, g.y, g.z );
}

void mappedTriangle() 
{
  stroke( 0, 0, 255 ); 
  line( a.x, a.y, a.z, b.x, b.y, b.z ); 
  line( b.x, b.y, b.z, c.x, c.y, c.z ); 
  line( a.x, a.y, a.z, c.x, c.y, c.z ); 
  strokeWeight( 1 ); 
  point(c.x, c.y, c.z);
  strokeWeight(1);

  PVector nTemp1= PVector.sub(b, a).cross(PVector.sub(c, a));
  nTemp1.normalize() ;
  n1 = nTemp1.get(); 
  n1.mult(30);  // the new normal (this should be the same as old if the rotation was correct
  n1.add(p);
  stroke( 20 );
  line(  p.x, p.y, p.z, n1.x, n1.y, n1.z ); // showing the new normal

  nn = PVector.angleBetween( n, n1 ); // angle between the normals for the two triangles
  println( nn );
}

void keyPressed()
{
  if ( !map)
  {
    map=true;
  }
  else
  {
    map=false;
  }
}
