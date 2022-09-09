var frequencyInput = document.querySelector("input[frequency]");
var orderInput = document.querySelector("input[order]");
var waveformInput = document.getElementById("waveform").elements["waveform"];
var canvas = document.querySelector("canvas");
var context = canvas.getContext("2d");

var TAU = Math.PI * 2.0;
var Scale = 64.0;
var time = 0.0;
var startTime = new Date().getTime();
var xvalues = [];
var xvaluePointer = 0;
var yvalues = [];
var yvaluePointer = 0;
var x = 128.0,
		y = 128.0;

// https://commons.wikimedia.org/wiki/File:Fourier_series_square_wave_circles_animation.gif
// https://htmlpreview.github.io/

function fourier(order) {
	        // order = Math.pow(-1, order) * (order % 5 + 1) * order;
	        order = Math.pow(-1, order) * (order % 5 + 1);
		var phase = order * time * TAU;
	        // console.log('order = ' + order);
	
		var radius = 4.0 / (order * Math.PI) * Scale;
	        if (radius < 0) { radius = (-1)*radius; }
	
		context.beginPath();
		context.lineWidth = 1.0;
		context.strokeStyle = "rgba(255,128,32,1.0)";
		context.arc(x, y, radius, 0, TAU);
		context.stroke();
	
		context.strokeStyle = "rgba(255,255,255,0.4)";
		context.moveTo(x, y);
		x += Math.cos(phase) * radius;
		y += Math.sin(phase) * radius;
		context.lineTo(x, y);
		context.stroke();
};

function connect() {
		context.beginPath();
		context.moveTo(x + 0.5, y + 0.5);
		context.lineTo(300 + 0.5, y + 0.5); // 256->300
		context.strokeStyle = "rgba(255,255,32,1.0)";
		context.stroke();
};

function drawShape() { // added
		xvalues[xvaluePointer++ & 255] = x;
	        yvalues[yvaluePointer++ & 255] = y;
		context.beginPath();
		context.strokeStyle = "rgba(0,0,255,1)";
		context.moveTo(256 + 0.5, y + 0.5);        
		for (var i = 1; i < 256; ++i) {
		     context.lineTo(xvalues[(xvaluePointer - i) & 255] + 0.5, yvalues[(yvaluePointer - i) & 255] + 0.5);			    	
		}
		context.stroke();
}

function drawWave() {
	        xvalues[xvaluePointer++ & 255] = x;
		yvalues[yvaluePointer++ & 255] = y;
		context.beginPath();
		context.strokeStyle = "rgba(0,255,0,1)";
		context.moveTo(300 + 0.5, y + 0.5); //256 
		for (var i = 1; i < 256; ++i) { // 256
				context.lineTo(350 + i + 0.5, yvalues[(yvaluePointer - i) & 255] + 0.5); // 256 --> 350
		}
		context.stroke();
}

(function frame() {
		canvas.width = canvas.clientWidth;
		canvas.height = canvas.clientHeight;
		x = 144.0;
		y = 128.0;
		switch (waveformInput.value) {
				case "square":
						for (var order = 0; order <= orderInput.value; order++) {
								fourier((order << 1) + 1);
						}
						break;
				case "sawtooth":
						for (var order = 1; order <= orderInput.value; order++) {
								fourier(order << 1);
						}
						break;
		}
		connect();
	        drawShape();
		drawWave();
		var now = new Date().getTime();
		time += (now - startTime) * Math.pow(10.0, frequencyInput.value);
		startTime = now;
		window.requestAnimationFrame(frame);
})();
