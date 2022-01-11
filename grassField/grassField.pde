import processing.svg.*;

GrassRow row;
Grass g;
GrassField field;
FlowField flowfield;

float percent = 0;
int loopLength = 5;

void setup() {
  size(800,300, P2D);
  smooth(8);
  PVector origin = new PVector(0, height/2);
  flowfield = new FlowField(80, 30, 0.05);
  // row = new GrassRow(20, 1, origin);
  field = new GrassField(4, height/3);
}

void render(float percent) {
  field.animateGrass(percent);
  field.display();
  stroke(0); 
  noFill(); 

}

void draw() {
  background(#6C0405);
  flowfield.display();
  field.display();
  // percent = (float)frameCount/(frameRate*loopLength);
  // render(percent);
}

void keyPressed() {
  if (key == 'r') {
    field.createNewField();
    flowfield.restartFlowField();
  }
  if (keyCode == UP) {
    field.incrementRotationAmount(PI/20);
  }
  if (keyCode == DOWN) {
    field.incrementRotationAmount(-PI/20);
  }
  if (keyCode == LEFT) {
    field.incrementNoiseMapScale(-0.001);
  }
  if (keyCode == RIGHT) {
    field.incrementNoiseMapScale(0.001);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if ( e < 0) {
    field.decrementNumGrass();
  } else {
    field.incrementNumGrass();
  }
}