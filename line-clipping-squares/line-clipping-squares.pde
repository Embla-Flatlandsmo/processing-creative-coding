import processing.svg.*;

public class SegmentParameters {
  public float tStart;
  public float tEnd;
  SegmentParameters() {
    tStart = 0.0;
    tEnd = 1.0;
  }

  void setError() {
    this.tStart = -1.0;
    this.tEnd = -1.0;
  }

  boolean isError() {
    if (this.tStart == -1.0 && this.tEnd == -1.0) {
      return true;
    }
    return false;
  }

}

SegmentParameters liangBarskyClip(float p, float q) {
  SegmentParameters endParams = new SegmentParameters();
  float r;
  if (p < 0.0) {
    r = q/p;

    if (r > endParams.tEnd) {

    }
  }

}

void setup() {
  stroke(255);
  colorMode(HSB, 360, 100, 100);
  size(450,450);
  smooth(4);
}

void render(float percent) {

}

void draw() {
  background(0, 0, 0, 255);
  stroke(0, 0, 100, 255);

  render(percent);
  percent = frameCount*100/numFrames;
  counter++;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    noiseSeed(seedNum);
    seedNum++;
    test = new SegmentMaker(2);
  }
}

void mousePressed() {
  test.createNewSegment(mouseX, mouseY);
}