let cam;
function setup() {
createCanvas(100, 100, WEBGL);
normalMaterial();
cam = createCamera();
}
function draw() {
background(200);
// look at a new random point every 60 frames
if (frameCount % 60 === 0) {
cam.lookAt(random(-50, 50), random(-50, 50), 0);
}
rotateX(frameCount * 0.01);
box(20);
}
