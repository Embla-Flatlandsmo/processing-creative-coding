import processing.svg.*;

int numFrames = 300;
int counter = 0;
float percent = 0;

void setup() {
  strokeWeight(2);
  stroke(255);
  colorMode(HSB, 360, 100, 100);
  size(450,450);
  smooth(4);
}

int num_x = 90;
int num_y = 90;
float noiseMapScale = 0.08;

void render(float percent) {
  for (int y = 0; y < num_y; y++) {
    for (int x = 0; x < num_x; x++) {
      float noise_val = noise(noiseMapScale*float(x)+noiseMapScale*(sin(radians(3.6*percent+10*x))), 
                              noiseMapScale*float(y)+noiseMapScale*(cos(radians(3.6*percent+10*y))));
      float angle = TWO_PI*noise_val;
      float pos_x = map(float(x), 0, num_x-1, 0, width);
      float pos_y = map(float(y), 0, num_y-1, 0, height);
      float hue = map(noise_val, 0, 1, 0, 80);
      color c = color(hue, 80, 80);
      stroke(c);
      pushMatrix();
      translate(pos_x, pos_y);
      rotate(angle);
      line(-30, 0, 30, 0);
      popMatrix();
    }
  }

  if (percent>0) {
    saveFrame("frames/frame_###.png");
  }
}

void draw() {
  background(20, 80, 80, 255);
  stroke(0, 0, 100, 255);
  percent = frameCount*100/numFrames;
  if (percent >= 100) {
    exit();
  } 
  counter++;
  render(percent);
}
