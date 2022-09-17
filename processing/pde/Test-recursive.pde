
// https://forum.processing.org/one/topic/update-screen-from-recursive-function.html
// https://cs.brynmawr.edu/Courses/cs110/spring2012/section01/slides/29-6.pdf
//  Uncaught SyntaxError: missing ] in index expression. 찾을수 없다.


String input = "0123";
int len = 3;

void setup() {
  size(300, 300);
  noLoop();
}

void draw() {
 
  background(255);
  line(0,0, width,height);
 
  recursiveCombinations(input, len, new String());
}


// the recursive function which generates all combinations in one go
void recursiveCombinations(String input, int depth, String output) {

  if (depth == 0) {

    // not sure why -'0' works to cast to an int... but it does!
    int r = (output.charAt(0) - '0') * (255/input.length());  // scale to 0-255 based on input size
    int g = (output.charAt(1) - '0') * (255/input.length());
    int b = (output.charAt(2) - '0') * (255/input.length());
    println(r + "\t" + g + "\t" + b);

    // should write the text to the screen and wait 2 seconds before continuing...
    fill(0);
    text(r + ", " + g + ", " + b, 20, height/2);
    delay(2000);
  }
  else {
    for (int i=0; i<input.length(); i++) {
      output += input.charAt(i);
      recursiveCombinations(input, depth-1, output);
      output = output.substring(0, output.length() - 1);
    }
  }
}


/*
String input[] = "0123";

void setup() { 
  size(300, 300); 
  noLoop();
 
  class RecTest extends Thread {
    // public void run() {
    void run() {
      reco(this, input, input.length(), "");
    }
  } 
  new RecTest().start();
}

void draw() {
  line(0, 0, width, height);
}

void reco(Thread thrd, String in, int dpth, String out) {
  if (dpth == 0) {   
    int r = (out.charAt(0) - '0') * (255/in.length()); 
    int g = (out.charAt(1) - '0') * (255/in.length());   
    int b = (out.charAt(2) - '0') * (255/in.length());   
    background(255);
    fill(0);
    text(r + ", " + g + ", " + b, 20, height/2);
    redraw();
    try {
      thrd.sleep(250);
    } catch(Throwable ex) {}
  } 
  else {   
    for (int i=0; i<input.length(); i++) {     
      out += input.charAt(i);   
      println(out); // KR
      reco(thrd, in, dpth-1, out);
      out = out.substring(0, out.length() - 1);
    }
  }
}
*/

