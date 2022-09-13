W=0
draw=_=>{W||(s=b=>`drop-shadow(0 0 ${b}px #eee)`,createCanvas(W=800,W).drawingContext.filter=s(1)+s(3)+s(9)+s(22),g=createGraphics(W,W,WEBGL).stroke`#つぶやきProcessing`.noFill())
g.clear().rotate(r=.004).rotateY(r).box(320).sphere(160).sphere(W*2)
background(0)
image(g,0,0)}
