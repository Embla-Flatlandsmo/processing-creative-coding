/**
 * Based on Gestaltung P.2.3.6
 */
import processing.svg.*;

// ArrayList<PShape> modules;
int numFrames = 300;
int counter = 0;
float percent = 0;
void setup() {
  // modules = new ArrayList<PShape>();
  // // The files must be in the data folder
  // // of the current sketch to load successfully
  // PShape shape = loadShape("14.svg");
  // modules.add(shape);
  // try {
  //   PShape shape2 = loadShape("15.svg");
  // } catch (NullPointerException e) {
  //   println("Could not load shape!");
  // }
  stroke(0);
  strokeWeight(12);
  rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  size(450,450);
  smooth();
}

void render(float percent) {
  rotStep = percent*0.9;
  color red = color(5, 90, 53);
  drawRect(300, rotStep, red);
  saveFrame("frames/frame_###.png");
}

int value = 0;
float rotStep = 0;

void drawRect(float size, float rot, color col) {
  if (size < 5.0) {
    return;
  }
  color new_color = color(hue(col), max(saturation(col)-7,0), min(brightness(col)+7,100));
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(rot));
  fill(col);
  rect(0,0, size, size);
  popMatrix();

  drawRect(size-20, rot+rotStep, new_color);
}

void draw() {
  // rotStep = mouseX;
  background(255, 0, 0);
  percent = frameCount*100/numFrames;
  if (percent >= 100) {
    exit();
  } 
  render(percent);
}
