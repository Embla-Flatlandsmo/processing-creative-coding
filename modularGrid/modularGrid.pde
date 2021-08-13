/**
 * Based on Gestaltung P.2.3.6
 */
import processing.svg.*;

boolean record = false;


float tileSize = 20;
int xNumTiles = 30;
int yNumTiles = 30;

int width = (int)round(tileSize*xNumTiles);
int height = (int)round(tileSize*yNumTiles);


ArrayList<PShape> modules;


boolean tiles[][] = new boolean[xNumTiles][yNumTiles];
boolean mirrored = false;

void settings() {
    size(width, height);
}

void setup() {
  modules = new ArrayList<PShape>();
  // The files must be in the data folder
  // of the current sketch to load successfully
  for (int i=0; i < 16; i++) {
      String shapeName;
      String num;
      if (i < 10) {
          num = "0"+str(i);
      } else {
          num = str(i);
      }
      shapeName = num+".svg";
      PShape shape = loadShape(shapeName);
      modules.add(shape);
  }
} 

void draw(){

  if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    beginRecord(SVG, "frame-####.svg");
  }
  background(255);
  if (mousePressed) {
    if (mouseButton == LEFT) setTile(true);
    if (mouseButton == RIGHT) setTile(false);
  }
  drawModules();
  if (record) {
      endRecord();
      record = false;
  }
//    shape(modules.get(0), 110, 90, 100, 100);  // Draw at coordinate (110, 90) at size 100 x 100
//    shape(modules.get(10), 280, 40);            // Draw at coordinate (280, 40) at the default size
}

void setTile(boolean on) {
    int xTile = floor(mouseX / tileSize);
    xTile = constrain(xTile, 0, xNumTiles-1);
    int yTile = floor(mouseY / tileSize);
    yTile = constrain(yTile, 0, yNumTiles-1);
    tiles[xTile][yTile]=on;
    if (mirrored) tiles[xNumTiles-xTile-1][yTile] = on;
}

void reflectTiles() {
    for (int xTile = 0; xTile < xNumTiles-1; xTile++) {
        for (int yTile = 0; yTile<yNumTiles-1; yTile++) {
            if ((tiles[xTile][yTile]) || (tiles[xNumTiles-xTile-1][yTile])) {
                tiles[xNumTiles-xTile-1][yTile] = true;
                tiles[xTile][yTile] = true;
            }
        }
    }
}

void drawModules() {
    for (int xTile=0; xTile<xNumTiles; xTile++) {
        for (int yTile=0; yTile<yNumTiles; yTile++) {
            if (tiles[xTile][yTile]) {
                int adjacentIndex = findAdjacentTiles(xTile, yTile);
                int posX = (int)round(tileSize*xTile);
                int posY = (int)round(tileSize*yTile);  

                shape(modules.get(adjacentIndex), posX, posY, tileSize, tileSize);
            }
        }
    }
}

int findAdjacentTiles(int xTile,int yTile) {
    int north = 8;
    int west = 4;
    int south = 2;
    int east = 1;

    int adjacencyIndex = 0;
    if (yTile > 0) {
        if (tiles[xTile][yTile-1]) {
            adjacencyIndex += north;
        }
    }

    if (yTile<yNumTiles-1) {
        if (tiles[xTile][yTile+1]) {
            adjacencyIndex += south;
        }
    } 

    if (xTile > 0) {
        if (tiles[xTile-1][yTile]) {
            adjacencyIndex += west;
        }
    }

    if (xTile < xNumTiles-1) {
        if (tiles[xTile+1][yTile]) {
            adjacencyIndex += east;
        }
    }

    return adjacencyIndex;
}

void keyPressed() {
    if (key == 'r') {
        reflectTiles();
        drawModules();
    }
    if (key == 'm' || key == 'M') {
        if (mirrored) mirrored = false;
        else mirrored = true;

        drawModules();
    }
    if (key == 'c') {
        tiles = new boolean[xNumTiles][yNumTiles];
    }
    if (key == 's') {
        record = true;
    }
}