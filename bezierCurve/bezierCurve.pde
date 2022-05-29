import processing.svg.*;

ArrayList<PVector> pts;
float t = 0.0;

PVector interpolate(PVector p1, PVector p2, float t)
{
    float new_x = (1.0-t)*p1.x + t*p2.x;
    float new_y = (1.0-t)*p1.y + t*p2.y;
    PVector new_point = new PVector(new_x, new_y);
    return new_point;
}

void fullDeCasteljau(ArrayList<PVector> points)
{
    float t_prime = 0;
    while (t_prime <= 1.0)
    {
        deCasteljau(points, t_prime);
        t_prime += 0.01;
    }
}

void deCasteljau(ArrayList<PVector> points, float t)
{
    int num_ctrl_points = points.size();

    fill(255);
    PVector[] deCasPt = new PVector[num_ctrl_points+1];
    for (int i = 0; i < num_ctrl_points; i++) {
        deCasPt[i] = points.get(i);
    }

    for (int i = 0; i < num_ctrl_points-1; i++) {
        stroke(color(255, 0, 0));
        line(deCasPt[i].x, deCasPt[i].y, deCasPt[i+1].x, deCasPt[i+1].y);
    }

    for (int r = 1; r < num_ctrl_points; r++) {
        for (int i = 0; i < num_ctrl_points-r; i++) {
            stroke(color(255, 0, 0));
            line(deCasPt[i].x, deCasPt[i].y, deCasPt[i+1].x, deCasPt[i+1].y);
            stroke(0);
            ellipse(deCasPt[i].x, deCasPt[i].y, 2,2);
            ellipse(deCasPt[i+1].x, deCasPt[i+1].y, 2,2);
            PVector new_point = interpolate(deCasPt[i], deCasPt[i+1], t);
            deCasPt[i]= new_point;
            // deCasPt.set(i, new_point);
        }
    }
    ellipse(deCasPt[0].x, deCasPt[0].y, 10,10);
    // ellipse(deCasPt.get(0).x, deCasPt.get(0).y, 3, 3);
}

void setup() {
    size(400, 400);
    smooth();
    rectMode(CORNER);
    pts = new ArrayList<PVector>();
    PVector p1 = new PVector(40, 40);
    PVector p2 = new PVector(300, 100);
    PVector p3 = new PVector(200, 300);
    PVector p4 = new PVector(350, 350);
    pts.add(p1);
    pts.add(p2);
    pts.add(p3);
    pts.add(p4);
} 
void render(float percent) {
    float t_value = 0.5+0.5*sin(2*PI*percent/100.0);
    deCasteljau(pts, t_value);

    fill(color(255, 204, 0));
    for (int i = 0; i < pts.size(); i++) {
        ellipse(pts.get(i).x, pts.get(i).y, 5, 5);
    }
    if (percent < 100.0)
    {
        saveFrame("frames/frame_###.png");
    }
}

float percent = 0.0;
void draw(){
    background(255);
    
    // deCasteljau(pts, t);

    // for (int i = 0; i < pts.size(); i++) {
    //     ellipse(pts.get(i).x, pts.get(i).y, 5, 5);
    // }
    render(percent);

    percent += 0.5;
    // if (percent > 100.0)
    // {
    //     percent -= 100;
    // }
    // drawValues(values);
//   if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    // beginRecord(SVG, "frame-####.svg");
//   }
//   if (mousePressed) {
//     if (!isDragged) prevTiles = copyArray(tiles);
//     if (mouseButton == LEFT) setTile(true);
//     if (mouseButton == RIGHT) setTile(false);
//     isDragged = true;
//   } else {
//     isDragged = false;
//   }
//   renderTiles();

//   if (record) {
//       endRecord();
//       record = false;
//   }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      t += 0.01;
      if (t > 1.0) {
          t = 1.0;
      }
    } else if (keyCode == DOWN) {
      t -= 0.01;
      if (t < 0.0)
      {
          t=0.0;
      }
    } 
  }
}