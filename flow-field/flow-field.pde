import processing.svg.*;

int numFrames = 300;
int counter = 0;
float percent = 0;
float noiseMapScale = 0.0008;
int seedNum = 0;


SegmentMaker test;
// class Unit {
//   PVector location, velocity

//   ArrayList<PVector> locations, velocities;

//   int length;

// class Segment {
//   PVector location, velocity, acceleration;

//   ArrayList<PVector> locations, velocities;

//   int length;

//   Segment(PVector origin, int length_) {
//     length = length_;

//     location = origin.get();
//     velocity = new PVector(0,0);
//     acceleration = new PVector(1,1);

//     locations = new ArrayList<PVector>();
//     velocities = new ArrayList<PVector>();

//     locations.add(location.get());
//     velocities.add(velocity.get());
//   }

//   void makePoints() {
//     for (int i = 0; i < length; i++) {
//       acceleration = new PVector(0,0);
//       velocity = velocities.get(i).get();
//       float randomRadian = noise((0.01*locations.get(i).x)*pow(0.99,i), (locations.get(i).y)*0.01*pow(0.99,i))*4*PI;
//       float randomMagnitude = noise((locations.get(i).x)*0.01*pow(0.99,i), (locations.get(i).y)*0.01*pow(0.99,i));

//       PVector dir = new PVector(cos(randomRadian), sin(randomRadian));
//       acceleration.set(dir);
//       acceleration.mult(randomMagnitude);

//       velocity.add(acceleration);
//       velocity.limit(3);

//       location.add(velocity);

//       velocities.add(velocity.get());
//       locations.add(location.get());
//     }
//   }

//   void display(float tentacleThickness, float strokeThickness, int col) {
//     stroke(#836DAA);
//     strokeWeight(tentacleThickness+strokeThickness);
//     for (int i = 0; i < length; i++) {
//       PVector currentLoc = locations.get(i);
//       point(currentLoc.x, currentLoc.y);
//     }
//     colorMode(HSB, 360, 100, 100);
//     stroke(col);
//     strokeWeight(tentacleThickness);

//     for (int i = 0; i < length; i++) {
//       PVector currentLoc = locations.get(i);
//       point(currentLoc.x, currentLoc.y);
//     }
//   }
// }


void drawFlowField(int numX, int numY) {
  for (int i = 0; i < numY; i++) {
    float yPos = map(i, 0, numY-1, 0, height);
    for (int j = 0; j < numX; j++) {
      float xPos = map(j, 0, numX-1, 0, width);
      float angle = noise(i*noiseMapScale, j*noiseMapScale)*TWO_PI;
      stroke(255);
      strokeWeight(2);
      pushMatrix();
      translate(xPos, yPos);
      rotate(angle);
      line(0,0,20,0);
      popMatrix();
    }
  }
}


class Segment {
  PVector location, velocity, acceleration;

  ArrayList<PVector> locations, velocities;

  ArrayList<PVector> points;

  int length;
  float segmentThickness;

  Segment(PVector origin, int length_) {
    segmentThickness = random(3,100);

    length = length_;

    location = origin.copy();
    velocity = new PVector(0,0);
    acceleration = new PVector(1,1);

    locations = new ArrayList<PVector>();
    velocities = new ArrayList<PVector>();
    points = new ArrayList<PVector>();

    locations.add(location.copy());
    velocities.add(velocity.copy());
  }

  void makePoints() {
    for (int i = 0; i < length*50; i++) {
      acceleration = new PVector(0,0);
      velocity = (velocities.get(i)).copy();
      float angleRad = noise(noiseMapScale*locations.get(i).x, noiseMapScale*locations.get(i).y)*TWO_PI;
      float magnitude = noise(noiseMapScale*locations.get(i).x, noiseMapScale*locations.get(i).y)*0.2;

      PVector dir = new PVector(cos(angleRad), sin(angleRad));
      acceleration.set(dir);
      acceleration.mult(magnitude);

      velocity.add(acceleration);
      velocity.limit(3);

      location.add(velocity);

      velocities.add(velocity.copy());
      locations.add(location.copy());
      if (i%length == 0) {
        points.add(location.copy());
        println("makePoints Input to noise = "+noiseMapScale*locations.get(i).x);
      }
    }
  }

  void setSegmentThickness(float thickness) {
    segmentThickness = thickness;
  }

  void display(int col) {
    stroke(#FFFFFF);
    strokeWeight(segmentThickness+1.5);
    beginShape();
    for (int i = 0; i < length; i++) {
      PVector currentLoc = points.get(i).copy();
      curveVertex(currentLoc.x, currentLoc.y);
    }
    endShape();
    stroke(col);
    strokeWeight(segmentThickness);

    beginShape();
    for (int i = 0; i < length; i++) {
      PVector currentLoc = points.get(i);
      curveVertex(currentLoc.x, currentLoc.y);
      // point(currentLoc.x, currentLoc.y);
    }
    endShape();

    // To understand what is going on
    strokeWeight(2);
    stroke(#FFFFFF);
    for (int i = 0; i < length; i++) {
      PVector currentLoc = points.get(i);
      ellipse(currentLoc.x, currentLoc.y, segmentThickness/2, segmentThickness/2);
    }
  }
}

class SegmentMaker {
  ArrayList<Segment> segments;

  SegmentMaker(int numSegments) {
    segments = new ArrayList<Segment>();
    for (int i = 0; i < numSegments; i++) {
      PVector origin = new PVector(random(width/2-200, width/2+200), random(height/2-200, height/2+200));
      int length = int(random(4,10));
      Segment new_seg = new Segment(origin, length);
      new_seg.setSegmentThickness(2);
      new_seg.makePoints();
      segments.add(new_seg);
    }
  }

  void createNewSegment(float posX, float posY) {
    PVector origin = new PVector(posX, posY);
    int length = int(random(4,10));
    Segment new_seg = new Segment(origin, length);
    new_seg.makePoints();
    segments.add(new_seg);
  }

  private float calculateMaxThickness(int segmentIndex) {
    float maxThickness = 50;
    for (int i = 0; i < segments.size(); i++) {
      if (i == segmentIndex) {
        continue;
      }
    }
    return 0.0;
  }

  void display() {
    color red = color(5,255,255);
    for (int i = 0; i < segments.size(); i++) {
      segments.get(i).display(red);
    }
  }
}

void setup() {
  stroke(255);
  colorMode(HSB, 360, 100, 100);
  size(450,450);
  smooth(4);
  test = new SegmentMaker(2);

  // test.makePoints();
  noiseSeed(seedNum);
  strokeCap(PROJECT);
  ellipseMode(RADIUS);
  noiseMapScale = 0.08;
  for (int i = 0; i < 10; i++) {
    float yPos = map(i, 0, 9, 0, height);
    for (int j = 0; j < 10; j++) {
      float xPos = map(j, 0, 9, 0, width);
      println("Input to noise field: "+xPos*noiseMapScale);
    }
  }
}

void render(float percent) {
  // curve(20, 104, 20, 104, 292, 96, 292, 244);
  // float strokeThickness = 2;
  // float segmentThickness = 20;
  // color red = color(5,255,255);
  test.display();
  stroke(0); 
  noFill();
  // float t = map(mouseX, 0, width, -5, 5);
  // curveTightness(t);  

}

void draw() {
  background(0, 0, 0, 255);
  stroke(0, 0, 100, 255);
  drawFlowField(20, 20);
  // if (percent>0) {
  //   saveFrame("frames/frame_###.png");
  // }
  // if (percent >= 100) {
  //   exit();
  // } 
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

/*
Mover: Update position based on flow field
Segment: Store coordinate for segments of x points
*/