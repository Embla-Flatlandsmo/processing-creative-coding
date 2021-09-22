import processing.svg.*;

int numFrames = 300;
int counter = 0;
float percent = 0;

// class Unit {
//   PVector location, velocity, acceleration;

//   ArrayList<PVector> locations, velocities;

//   int length;

//   Unit(PVector origin, int length_) {
//     //Initialize variables
//     length = length_;

//     location = origin.get();
//     velocity = new PVector(0,0);
//     acceleration = new PVector(1,1);

//     locations = new ArrayList<PVector>();
//     velocities = new ArrayList<PVector>();

//     locations.add(location.get());
//     velocities.add(velocity.get());
// }

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
  // for (int x=0; x < width; x++) {
  //   float noiseVal = noise((mouseX+x)*noiseMapScale, mouseY*noiseMapScale);
  //   stroke(noiseVal*255);
  //   line(x, mouseY+noiseVal*80, x, height);
  // }
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
  // curve(20, 104, 20, 104, 292, 96, 292, 244);

  // line(120, 80, 340, 300);
  // stroke(0); 
  // float t = map(mouseX, 0, width, -5, 5);
  // curveTightness(t);
  // beginShape();
  // curveVertex(10, 26);
  // curveVertex(10, 26);
  // curveVertex(83, 24);
  // curveVertex(83, 61);
  // curveVertex(25, 65); 
  // curveVertex(25, 65);
  // endShape();

  // pushMatrix();
  // translate(width/2, height/2);
  // rotate(radians(percent*3.6));
  // color start_color = color(0, 100, 100);
  // color end_color = color(0, 0, 0);
  // color frame_col = lerpColor(start_color, end_color, 0.5*(1+sin(radians(percent*3.6))));
  // fill(frame_col);
  // float amplitude = cos(radians(percent*3.6))*100;
  // for (int i = 0; i < num_dots; i++) {
  //   float x_offset = cos(radians(i*360/num_dots))*amplitude;
  //   float y_offset = sin(radians(i*360/num_dots))*amplitude;
  //   ellipse(x_offset, y_offset, 5*(2+cos(radians(percent*3.6))), 5*(2+cos(radians(percent*3.6))));
  // }
  // popMatrix();

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
