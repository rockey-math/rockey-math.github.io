String input = "0123";
// https://forum.processing.org/one/topic/update-screen-from-recursive-function.html

void setup() { 
  size(300, 300); 
  noLoop();
 
  class RecTest extends Thread {
    public void run() {
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
      reco(thrd, in, dpth-1, out);
      out = out.substring(0, out.length() - 1);
    }
  }
}
