import processing.svg.*;

int numFrames = 150;
int counter = 0;
float percent = 0;

void setup() {
  noStroke();
  colorMode(HSB, 360, 100, 100);
  size(450,450);
  smooth(4);
}


void render(float percent) {
  float ellipse_max_size = 20.0;
  float ellipse_min_size = 10.0;
  float overflow_amount = 20.0;
  for (float j = 0.0; j < height/ellipse_max_size; j++) {
    for (float i = 0.0; i < width/ellipse_max_size; i++) {
      float pos_x = (i+0.5)*ellipse_max_size;
      float pos_y = (j+0.5)*ellipse_max_size;
      float d = dist(pos_x, pos_y, width/2+100*cos(radians(3.6*percent)), height/2+100*sin(radians(3.6*percent)));
      float d2 = min(d, 100);
      float maxDist = dist(0, 0, width, 0);
      float size = map(d2, 100, 0, ellipse_min_size, ellipse_max_size+overflow_amount);
      ellipse(pos_x, pos_y, size, size);
    }
  }

  if (percent>0) {
    saveFrame("frames/frame_###.png");
  }
}

void draw() {
  fill(3,100,100,255);
  background(0,0,0,100);
  percent = counter*100/numFrames;
  if (percent >= 100) {
    exit();
  } 
  counter++;
  render(percent);
}
