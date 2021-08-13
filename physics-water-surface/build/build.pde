WaterLine water;


void setup() {
	size(800,600);
	frameRate(60);
	background(0);
	water = new WaterLine(800,0.001,0.05, 0.45);

}

void draw() {
	colorMode(HSB);
	background(0,0,100);
	setGradient(0,0,width,height,color(0,0,50),color(0,0,80));

	water.run();
}

void mousePressed() {
	water.splash(mouseX, 200);
}

void setGradient(int x, int y, float w, float h, color c1, color c2) {
	noFill();
	for (int i = y; i <= y+h; i++) {
		float inter = map(i, y, y+h, 0, 1);
		color c = lerpColor (c1, c2, inter);
		stroke(c);
		line(x,i,x+w,i);
	}
}

//Class for the individual points
class Spring {
	public float position;
	public float velocity;

	Spring() {
		position = 0;
		velocity = 0;
	}

	float getPosition() {
		return position;
	}

	void setVelocity(float speed) {
		velocity = speed;
	}

	void addVelocity(float speed) {
		velocity += speed;
	}

	void addPosition(float pos) {
		position += pos;
	}

	void update(float dampening, float tension) {
		position += velocity;
		//First part is Hooke's law, second part is friction/dampening
		float acceleration = (-1)*tension*position - dampening*velocity;
		
		//Euler's method
		velocity += acceleration;
		acceleration = 0;
	}

	void display(float x, float offset) {
		colorMode(HSB);
		fill(0,0,100);
		noStroke();
		rectMode(CORNER);
		rect(x,position+offset,2,height-(position+offset));

		/*
		ellipseMode(CENTER);
		fill(0);
		ellipse(x,position+offset,2,2);
		*/
	}
}

class WaterLine {
	ArrayList<Spring> springs;
	ArrayList<Float> xpoints;
	//private Spring[] springs;
	//private float[] xpoints;
	private int numPoints;
	private float dampening;
	private float tension;
	private float spread;
	private float centerY;

	WaterLine(int npoints, float dampening, float tension, float spread) {
		centerY = height/2;
		numPoints = npoints;
		this.dampening = dampening;
		this.tension = tension;
		this.spread = spread;
		springs = new ArrayList<Spring>();
		xpoints = new ArrayList<Float>();

		for (int i = 0; i < numPoints; i++) {
			springs.add(new Spring());
			xpoints.add(float(i));
		}
	}

	void splash(int index, float speed) {
		if ((index >= 0) && (index < numPoints)) {
			Spring s = springs.get(index);
			s.setVelocity(speed);
		}
	}

	void run() {

		for (int i = 0; i < numPoints; i++) {
			Spring s = springs.get(i);
			s.update(dampening,tension);
			if (i%10 == 0) {
				s.display(xpoints.get(i), centerY);
			}
		}

		ArrayList<Float> leftDeltas = new ArrayList<Float>();
		ArrayList<Float> rightDeltas = new ArrayList<Float>();

		for (int i = 0; i < numPoints; i++) {
			leftDeltas.add(0.0);
			rightDeltas.add(0.0);
		}

		for (int j = 0; j < 8; j++) {
			for (int i = 0; i < numPoints; i++) {
				Spring s_i = springs.get(i);
				if (i > 0) {
					Spring s_i_prev = springs.get(i-1);
					leftDeltas.set(i, (spread * (s_i.position - s_i_prev.position)));
					s_i_prev.velocity += leftDeltas.get(i);
				}
				if (i < springs.size() - 1) {
					Spring s_i_next = springs.get(i+1);
					rightDeltas.set(i, spread * (s_i.position - s_i_next.position));
					s_i.velocity += rightDeltas.get(i);
				}
			}

			for (int i = 0; i < numPoints; i++) {
				Spring s_i = springs.get(i);
				if (i > 0) {
					Spring s_i_prev = springs.get(i-1);
					s_i_prev.position += leftDeltas.get(i);
				}
				if (i < numPoints-1) {
					Spring s_i_next = springs.get(i+1);
					s_i_next.position += rightDeltas.get(i);
				}
			}
		}
	}



}