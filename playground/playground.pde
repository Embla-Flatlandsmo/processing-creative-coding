import processing.svg.*;

int numFrames = 300;
int counter = 0;
float percent = 0;

void setup() {
  stroke(0);
  strokeWeight(12);
  colorMode(HSB, 360, 100, 100);
  size(450,450);
  smooth();
}

void render(float percent) {
  noFill();
  int arc_size = 100;
  color start_color = color(0,100,100);
  color end_color = color(100, 100, 100);
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(start_color, end_color, inter);
    stroke(c);
    line(0,i,width,i);
  }

  fill(0,100,20,150);
  noStroke();
  rect(0,0,width,height);
  noFill();

  for (int x = 0; x < width/arc_size+2; x++) {
    for (int y = 0; y < height/(arc_size*0.1)+20; y++) {
      float current_col = map(y, 0, height/(arc_size*0.1)+20, 0, 1);
      color row_col = lerpColor(start_color, end_color, current_col);
      int x_multiplier = 1;
      if (x%2==0) x_multiplier = -1;
      strokeWeight(3);
      stroke(row_col);
      arc(x*arc_size, y*arc_size*0.08-50, arc_size+(20*sin(radians(20*y+percent*3.6))*x_multiplier), arc_size, radians(5), radians(175));
    }
  }
  saveFrame("frames/frame_###.png");
}

void draw() {
  background(0, 0, 0);
  percent = frameCount*100/numFrames;
  if (percent >= 100) {
    exit();
  } 
  render(percent);
}
