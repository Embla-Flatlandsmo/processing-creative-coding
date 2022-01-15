/**
 * Based on Gestaltung P.2.3.6
 */
import processing.svg.*;

boolean record = false;

int tileSize = 20;
int xNumTiles = 30;
int yNumTiles = 30;

int width = (int)round(tileSize*xNumTiles);
int height = (int)round(tileSize*yNumTiles);

boolean templateExists = false;
String templateName;
PImage templateImage;
ArrayList<PShape> modules;

// boolean tiles[][];
// boolean prevTiles[][]; // for one-step ctrl-z

// Workspace settings
boolean mirrored = false;
boolean pixelView = false;
boolean isDragged = false;

void undo() {
    boolean tmpTiles[][] = copyArray(tiles);
    tiles = copyArray(prevTiles);
    prevTiles = copyArray(tmpTiles);
    renderTiles();
}

void importImage() {
    templateImage = loadImage(templateName);
    if (templateImage == null) return ;
    templateImage.loadPixels();
    if (templateImage.width == -1 || templateImage.height == -1) return;

    color threshold = #808080;
    templateImage.filter(THRESHOLD);
    
    width = templateImage.width;
    height = templateImage.height;
    xNumTiles = width;
    yNumTiles = height;
    templateExists = true;
}

void setTemplateImage() {
    if (!templateExists) return;
    color black = color(0,0,0);

    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            if (templateImage.pixels[y*width+x] == #000000) {
                tiles[x][y] = true;
            } else {
                tiles[x][y] = false;
            }
        }
    }
}

void settings() {
    /*Load settings */
    String[] settings = loadStrings("data/settings.txt");

    for(String s:settings){
        String[] setting=s.split("=");
        switch(setting[0].trim().toLowerCase()) {
            case "tilesize":
                tileSize = Integer.valueOf(setting[1]);
                break;
            case "xnumtiles":
                xNumTiles = Integer.valueOf(setting[1]);
                break;
            case "ynumtiles":
                yNumTiles = Integer.valueOf(setting[1]);
                break;
            case "templatename":
                templateName = setting[1];
                importImage();
            default:
                println("No settings found");
                break;
        }
    }
    tiles = new boolean[xNumTiles][yNumTiles];
    prevTiles = new boolean[xNumTiles][yNumTiles];
    setTemplateImage();
    int width = (int)round(tileSize*xNumTiles);
    int height = (int)round(tileSize*yNumTiles);
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

void renderTiles() {
    background(255);
    if (pixelView) drawPixels();
    else drawModules();
}

void draw(){
  if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    beginRecord(SVG, "frame-####.svg");
  }
  if (mousePressed) {
    if (!isDragged) prevTiles = copyArray(tiles);
    if (mouseButton == LEFT) setTile(true);
    if (mouseButton == RIGHT) setTile(false);
    isDragged = true;
  } else {
    isDragged = false;
  }
  renderTiles();

  if (record) {
      endRecord();
      record = false;
  }
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

void drawPixels() {
    fill(0);
    for (int xTile=0; xTile<xNumTiles; xTile++) {
        for (int yTile=0; yTile<yNumTiles; yTile++) {
            if (tiles[xTile][yTile]) {
                int posX = (int)round(tileSize*xTile);
                int posY = (int)round(tileSize*yTile); 
                rect(posX, posY, tileSize, tileSize);
            }
        }
    } 
}

void exportTiles() {
    PImage image = createImage(xNumTiles, yNumTiles, RGB);
    color black = color(0);
    color white = color(255);
    for (int xTile=0; xTile<xNumTiles; xTile++) {
        for (int yTile=0; yTile<yNumTiles; yTile++) {
            if (tiles[xTile][yTile]) {
                image.pixels[yTile*xNumTiles+xTile] = black;
            } else {
                image.pixels[yTile*xNumTiles+xTile] = white;
            }
        }
    } 
    image.save("pixelMap.png");
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
    if (key == 26) {
        //ctrl-Z
        println("ctrl-Z");
        undo();
    }
    switch (str(key).toLowerCase()) {
        case "r":
            prevTiles = copyArray(tiles);
            reflectTiles();
            renderTiles();
            break;
        case "c":
            prevTiles = copyArray(tiles);
            tiles = new boolean[xNumTiles][yNumTiles];
        break;
        case "m":
            mirrored = !mirrored;
            renderTiles();
            break;
        case "l":
            prevTiles = copyArray(tiles);
            setTemplateImage();
            break;
        case "s":
            if (pixelView) {
                exportTiles();
            } else {
                record = true;
            }
            break;
        case "p":
            pixelView = !pixelView;
            break;
        default:
        break;
    }
}

boolean[][] copyArray(boolean[][] matrix) {
    boolean[][] newArray = new boolean[matrix.length][];
    for (int i = 0; i < matrix.length; i++) {
        newArray[i] = matrix[i].clone();
    }
    return newArray;
}