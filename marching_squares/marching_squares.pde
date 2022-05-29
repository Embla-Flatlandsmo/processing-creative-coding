import processing.svg.*;

MarchingSquares squares;
float threshold = 0.5;

void setup() {
    size(400, 400);
    smooth();
    rectMode(CORNER);
    squares = new MarchingSquares(float(400)/20, 20,20);
    squares.setThreshold(threshold);
} 

void draw(){
    background(0);
    squares.draw();
    squares.drawLines();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      threshold += 0.05;
    } else if (keyCode == DOWN) {
      threshold -= 0.05;
    } 
    squares.setThreshold(threshold);
  }
}