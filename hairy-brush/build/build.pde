import java.util.ArrayList;
import java.io.*; 
import java.util.*;

ArrayList<Particle> pts;
boolean onPressed;

void setup() {
	size(720,720,P2D);
	smooth(2);
	frameRate(30);
	colorMode(HSB);
	rectMode(CENTER);

	pts = new ArrayList<Particle>();
/*
	for (int x = 0; x < width; x += 5) {
		for (int y = 0; y < height; y += 5) {
			Particle p = new Particle(x,y,0,0);
			pts.add(p);
		}
	}
*/
	onPressed = false;

	background(0);
}

void draw() {

	if (onPressed) {
		for (int i = 0; i<10; i++) {
		Particle p = new Particle(mouseX, mouseY,i,i);
		pts.add(p);
		}
	}

	Iterator<Particle> it = pts.iterator();
	while (it.hasNext()) {
		Particle p = it.next();
		p.update();
		p.display();
		if (p.dead) {
			it.remove();
		}
	}
}

void mousePressed() {
	onPressed = true;
}


void mouseReleased() {
	onPressed = false;
}

void keyPressed() {
	if (key == 'c') {
		pts.clear();
		background(0);
	}
}



class Particle{
	PVector location, velocity, acceleration;
	int lifeSpan, passedLife;
	float alpha, size, sizeRange, decay, xOffset, yOffset;
	boolean dead;
	color c;

	Particle(float x, float y, float xOffset, float yOffset) {
		location = new PVector(x,y);

		//Random intial velocity in random direction
		float randDegrees = random(360);
		velocity = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
		velocity.mult(random(5));

		//Initial conditions
		acceleration = new PVector(0,0);
		lifeSpan = int(random(30,90));
		passedLife = 0;
		decay = random(0.75,0.9);
		sizeRange = random(3,50);
		dead = false;

		colorMode(HSB,360,100,100);
		c = color(random(0,60), random(40,90), 1);

		this.xOffset = xOffset;
		this.yOffset = yOffset;
	}

	void update() {
		if (passedLife>= lifeSpan) {
			dead = true;
		} else {
			passedLife++;
		}

		alpha = float(lifeSpan-passedLife)/lifeSpan * 70 + 50;
		size = float(lifeSpan-passedLife)/lifeSpan * sizeRange;

		acceleration.mult(0);

		float randomRadian = noise((location.x+frameCount+xOffset)*0.01, (location.y+frameCount+yOffset)*0.01)*4*PI;
		float randomMagnitude = noise((location.x+xOffset)*0.01, (location.y+yOffset)*0.01);

		PVector dir = new PVector(cos(randomRadian), sin(randomRadian));
		acceleration.add(dir);
		acceleration.mult(randomMagnitude);

		velocity.add(acceleration);
		velocity.mult(decay);
		velocity.limit(3);

		location.add(velocity);
		float hue = hue(c);
		float saturation = saturation(c);
		float brightness = brightness(c);
		if (brightness <= 80) {
			brightness += 2;
		}

		c = color(hue,saturation,brightness);

	}

	void display() {
		strokeWeight(size+1.5);
		stroke(0,alpha);
		point(location.x,location.y);
		point(width-location.x,location.y);

		strokeWeight(size);
		stroke(c);
		point(location.x,location.y);
		point(width-location.x,location.y);
	}
}