/*ArrayList<Mover> tentacles;
int saves;
String filename;

void setup() {
	saves = 0;
	colorMode(HSB,360,100,100);
	filename = "squid_";
	tentacles = new ArrayList<Mover>();
	smooth(4);
	size(1920,1080,P2D);
	background(#FFFFFF);
	frameRate(2);

	for (int i = 0; i < 50; i++) {
		float x = random(-3,+3);
		float y = random(-3,+3);	
		float prob = random(0,1);			
		if (prob < 0.5) {
			Mover m1 = new Mover(x, y, int(3*random(40,100)));
			m1.makePoints(2*x,2*y);
			tentacles.add(m1);				
		} else if ( (0.5 < prob) &&  prob < 0.7) {
			Mover m1 = new Mover(x, y, int(3*random(80,500)));
			m1.makePoints(2*x,2*y);	
			tentacles.add(m1);
		} else {
			Mover m1 = new Mover(x, y, int(3*random(80,200)));
			m1.makePoints(2*x,2*y);	
			tentacles.add(m1);
		}
	}
}

void draw() {
	pushMatrix();

	translate(width/2,height/2);
	scale(3);
	for (int i = 0; i < tentacles.size(); i++) {
		stroke(0);
		strokeWeight(2);
		Mover currentTentacle = tentacles.get(i);
		currentTentacle.display();

		stroke(currentTentacle.getCol());
		strokeWeight(1);
		currentTentacle.display();
	}
	popMatrix();

}

void keyPressed() {
	if (key == 'c') {
		tentacles.clear();
		randomSeed(frameCount);
		noiseSeed(frameCount);
		background(#FFFFFF);
		for (int i = 0; i < 50; i++) {
			float x = random(-10,+10);
			float y = random(-10,+10);
			float prob = random(0,1);			
			if (prob < 0.6) {
				Mover m1 = new Mover(x, y, int(random(40,100)));
				m1.makePoints(2*x,2*y);
				tentacles.add(m1);				
			} else if ( (0.6 < prob) &&  prob < 0.7) {
				Mover m1 = new Mover(x, y, int(random(80,500)));
				m1.makePoints(2*x,2*y);	
				tentacles.add(m1);
			} else {
				Mover m1 = new Mover(x, y, int(random(80,150)));
				m1.makePoints(2*x,2*y);	
				tentacles.add(m1);
			}
		}
	}

	if (key == 's') {
		String name = filename + str(saves);
		save(name);
		saves++;
	}
}




class Mover {
	PVector location, velocity, acceleration;
	ArrayList<PVector> locations, velocities;
	int length;

	color c;

	Mover(float x, float y, int length) {
		locations = new ArrayList<PVector>();
		velocities = new ArrayList<PVector>();
		location = new PVector(x,y);
		velocity = new PVector(random(-1,1),random(-1,1));
		acceleration = new PVector(0,0);
		this.length = length;
		c = color(random(0,36), random(30,85), random(40,100));

	}

	color getCol() {
		return c;
	}

	void makePoints(float xOffset, float yOffset) {
		for (int i = 0; i < length; i++) {
			locations.add(location.get());
			acceleration.mult(0);

			float randomRad = 2*TWO_PI*noise((location.x/pow(i+10,1/6)+xOffset)*0.01, (location.y/pow(i+10,1/6)+yOffset)*0.01);
			float randomMag = noise(100+(location.x+xOffset)*0.01, 100+(location.y+yOffset)*0.01);
			PVector dir = new PVector(cos(randomRad), sin(randomRad));
			acceleration = dir.get();
			acceleration.mult(randomMag);

			velocity.add(acceleration);
			velocity.limit(0.5);
			location.add(velocity);


			velocities.add(velocity.get());
			locations.add(location.get());
		}
	}

/*
	void update() {
		for (int i = 0; i < 100; i++) {
			acceleration.mult(0);

			float randomRad = 2*TWO_PI*noise((locations.get(i).x)*0.01, (locations.get(i).y)*0.01);
			float randomMag = noise(100+(locations.get(i).x+frameCount)*0.01, 100+(locations.get(i).y+frameCount)*0.01);
			PVector dir = new PVector(cos(randomRad), sin(randomRad));
			acceleration = dir.get();
			acceleration.mult(randomMag);

			PVector currentVelocity = velocities.get(i);
			PVector newVelocity = currentVelocity.add(acceleration);

			PVector currentLocation = locations.get(i);
			PVector newLocation = currentLocation.add(newVelocity);
			velocities.set(i, newVelocity);

			locations.set(i,newLocation);
		}
	}

	void display() {
		for (int i = 0; i < locations.size(); i++) {
			point(locations.get(i).x, locations.get(i).y);
		}
	}
}






/*
Tentacle t;

void setup() {
	size(600,600);
	background(255);
	t = new Tentacle(new PVector(width/2, height/2), 30);
	t.makeTentacle();
	t.display();
}

void draw() {
	t.display();
}

class Tentacle {
	PVector location;
	ArrayList<PVector> locations;
	int nlocations;
	PShape path;

	Tentacle(PVector origin, int nlocations) {
		this.nlocations = nlocations;
		this.location = origin;
		locations = new ArrayList<PVector>();
		path = createShape();
	}

	void makeTentacle() {
		while (nlocations>0) {
			locations.add(location);
			nlocations--;
			location.x += 20*noise(location.x);
			location.y += 20*noise(location.y);
		}

		path.beginShape();
		for (int i = 0; i < locations.size(); i++) {
			if (i == 0 || i == locations.size()-1) {
				path.curveVertex(locations.get(i).x, locations.get(i).y);
			}
			path.curveVertex(locations.get(i).x, locations.get(i).y);
		}
		path.endShape(CLOSE);
	}

	void display() {
		strokeWeight(10);
		stroke(0);

		shape(path);
	}
}
*/

Tentacles t;
PVector loc;
boolean instruction;
PFont f;

void setup() {
	instruction = true;
  size(600,600,P2D);
  background(#FFFFFF);
  loc = new PVector(width/2, height/2);
  t = new Tentacles(loc, 100, 300, 4, 2, 230);
  smooth(8);
    f = createFont("Calibri", 24, true);
}

void draw() {
	  background(#FFFFFF);


  	t.display();
	  if (instruction) {
    	fill(128);
    	textAlign(CENTER, CENTER);
    	textFont(f);
    	textLeading(36);
    	text("Click on the canvas to reposition the head upon generation" + "\n" +
     	 "Press 'c' to generate a new jellyfish!" + "\n"
     	 , width*0.5, height*0.5);
  }
}

void mousePressed() {
  loc = new PVector(mouseX, mouseY);
}

void keyPressed() {
  if (key == 'c') {
		instruction = false;
    noiseSeed(frameCount);
    randomSeed(frameCount);
    t = new Tentacles(loc, 100, 300, 4, 2, 230);

  }
}

class Tentacles {
  ArrayList<Tentacle> tentacles;
  ArrayList<Integer> colors;
  PVector origin;
  float length, tentacleThickness, strokeThickness;
  int count; //number of tentacles

  Tentacles(PVector origin_, int count_, float length_, float tentacleThickness_, float strokeThickness_, float hue) {
    tentacles = new ArrayList<Tentacle>();
    colors = new ArrayList<Integer>();
    origin = origin_.get();
    length = length_;
    count = count_;

    tentacleThickness = tentacleThickness_;
    strokeThickness = strokeThickness_;

    colorMode(HSB,360,100,100);
    //Weighted random lengths. We want some short, mostly medium and some long
    for (int i = 0; i < count; i++) {
      float prob = random(0,1);
      float randomX = random(-10,10);
      float randomY = random(-10,10);
      float x = randomX + origin.x;
      float y = randomY + origin.y;

      int c = int(color(random(hue-20, hue+20), random(10,25), random(75,90)));
      colors.add(c);

      if (prob < 0.3) { //short tentacles
          Tentacle currentTentacle = new Tentacle(new PVector(x,y), int(length*random(0.1,0.3)));
          currentTentacle.makePoints();
          tentacles.add(currentTentacle);
      } else if (prob < 0.9) { // (if 0.3<prob<0.9): medium tentacles
          Tentacle currentTentacle = new Tentacle(new PVector(x,y), int(length*random(0.4,0.6)));
          currentTentacle.makePoints();
          tentacles.add(currentTentacle);
      } else { //long tentacles
          Tentacle currentTentacle = new Tentacle(new PVector(x,y), int(length*random(0.6,1)));
          currentTentacle.makePoints();
          tentacles.add(currentTentacle);
      }
    }
      }

    void display() {
        for (int i = 0; i < count; i++) {
          Tentacle currentTentacle = tentacles.get(i);
          currentTentacle.display(tentacleThickness,strokeThickness, colors.get(i));          
        }
        ellipseMode(RADIUS);
        stroke(#836DAA);
        strokeWeight(strokeThickness);
        fill(colors.get(0));
        ellipse(origin.x, origin.y, 20, 20);
    }
}


class Tentacle {
  PVector location, velocity, acceleration;

  ArrayList<PVector> locations, velocities;

  int length;

  Tentacle(PVector origin, int length_) {
    //Initialize variables
    length = length_;

    location = origin.get();
    velocity = new PVector(0,0);
    acceleration = new PVector(1,1);

    locations = new ArrayList<PVector>();
    velocities = new ArrayList<PVector>();

    locations.add(location.get());
    velocities.add(velocity.get());
  }

  void makePoints() {
    for (int i = 0; i < length; i++) {
      acceleration = new PVector(0,0);
      velocity = velocities.get(i).get();
      float randomRadian = noise((0.01*locations.get(i).x)*pow(0.99,i), (locations.get(i).y)*0.01*pow(0.99,i))*4*PI;
      float randomMagnitude = noise((locations.get(i).x)*0.01*pow(0.99,i), (locations.get(i).y)*0.01*pow(0.99,i));

      PVector dir = new PVector(cos(randomRadian), sin(randomRadian));
      acceleration.set(dir);
      acceleration.mult(randomMagnitude);

      velocity.add(acceleration);
      velocity.limit(3);

      location.add(velocity);

      velocities.add(velocity.get());
      locations.add(location.get());
    }
  }

  void display(float tentacleThickness, float strokeThickness, int col) {
    stroke(#836DAA);
    strokeWeight(tentacleThickness+strokeThickness);
    for (int i = 0; i < length; i++) {
      PVector currentLoc = locations.get(i);
      point(currentLoc.x, currentLoc.y);
    }


    colorMode(HSB, 360, 100, 100);
    stroke(col);
    strokeWeight(tentacleThickness);

    for (int i = 0; i < length; i++) {
      PVector currentLoc = locations.get(i);
      point(currentLoc.x, currentLoc.y);
    }
  }
}