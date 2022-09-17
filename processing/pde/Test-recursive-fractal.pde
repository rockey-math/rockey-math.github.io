// https://cs.brynmawr.edu/Courses/cs110/spring2012/section01/slides/29-6.pdf

FractalTree f;
void setup() {
size(600, 600);
smooth();
background(255);
f = new FractalTree(-200, 10);
translate(300, 600);
f.draw(50);
println(f.countBranches());
}


class FractalTree {
float len;
FractalTree left; // Left branch
FractalTree right; // Right branch
FractalTree(float len, int depth) {
this.len = len;
if (depth > 1) {
depth--;
left = new FractalTree(0.6*len, depth);
right = new FractalTree(0.6*len, depth);
}
}
void draw(float angle) {
stroke(0);
line(0, 0, 0, len);
if (left != null && right != null) {
translate(0, len);
pushMatrix();
rotate( radians(angle) );
left.draw(angle);
popMatrix();
pushMatrix();
rotate( radians(-angle) );
right.draw(angle);
popMatrix();
}}}
