/**
 * Based on Gestaltung P.2.3.6
 */
import processing.svg.*;
import java.util.Map;

boolean record = false;

int tileSize = 20;
int xNumTiles = 30;
int yNumTiles = 30;

int width = (int)round(tileSize*xNumTiles);
int height = (int)round(tileSize*yNumTiles);

boolean templateExists = false;
String templateName;
PImage templateImage;
// ArrayList<Tile> modules;
HashMap<String, ArrayList<PShape>> modules;

boolean tiles[][];
boolean prevTiles[][]; // for one-step ctrl-z

// Workspace settings
boolean mirrored = false;
boolean pixelView = false;
boolean isDragged = false;

// class Tile {
//     ArrayList<PShape> modules;
//     int numModules;
//     int rotation;

//     Tile(int rotation) {
//         modules = new ArrayList<PShape>();
//         rotation = rotation;
//         numModules = 0;
//     }

//     int getRotation() {
//         return rotation;
//     }

//     PShape getModule(int index) {
//         return modules.get(index % numModules);
//     }
// }

ArrayList<PShape> loadModules(String tileName) {
    ArrayList<PShape> tiles = new ArrayList<PShape>();
    int i = 0;
    while (true) {
        try {
            String num;
            if (i<10) {
                num = "0"+str(i);
            } else {
                num = str(i);
            }
            String shapeName = tileName+"_"+num+".svg";
            PShape shape = loadShape(shapeName);
            tiles.add(shape);
            i++;
            println("Added shape: "+shapeName);
        } catch (NullPointerException e) {
            break;
        }
    }
    return tiles;
}

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
    modules = new HashMap<String, ArrayList<PShape>>();
    // The files must be in the data folder
    // of the current sketch to load successfully
    ArrayList<PShape> islands = loadModules("island");
    modules.put("island", islands);
    ArrayList<PShape> intersections = loadModules("intersection");
    modules.put("intersection", intersections);
    ArrayList<PShape> ends = loadModules("end");
    modules.put("end", ends);
    ArrayList<PShape> corners = loadModules("corner");
    modules.put("corner", corners);
    ArrayList<PShape> bridges = loadModules("bridge");
    modules.put("bridge", bridges);
    ArrayList<PShape> t = loadModules("T");
    modules.put("T", t);

}

void renderTiles() {
    background(255);
    if (pixelView) drawPixels();
    else drawModules();
}

void draw(){
  if (mousePressed) {
    if (!isDragged) prevTiles = copyArray(tiles);
    if (mouseButton == LEFT) setTile(true);
    if (mouseButton == RIGHT) setTile(false);
    isDragged = true;
    renderTiles();
  } else {
    isDragged = false;
  }

    if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    beginRecord(SVG, "frame-####.svg");
    renderTiles();
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
    shapeMode(CENTER);
    for (int xTile=0; xTile<xNumTiles; xTile++) {
        for (int yTile=0; yTile<yNumTiles; yTile++) {
            if (tiles[xTile][yTile]) {
                int adjacentIndex = findAdjacentTiles(xTile, yTile);
                int posX = (int)round((tileSize+0.5)*xTile);
                int posY = (int)round((tileSize+0.5)*yTile);  
                String moduleName = getKeyFromIndex(adjacentIndex);
                float rotation = getRotationFromIndex(adjacentIndex);
                ArrayList<PShape> possibleModules = modules.get(moduleName);
                PShape module = possibleModules.get(0);
                pushMatrix();
                translate(posX, posY);
                rotate(rotation);
                shape(module, 0, 0, tileSize, tileSize);
                popMatrix();
            }
        }
    }
}

String getKeyFromIndex(int index) {
    switch (index) {
    case 0: return "island";
    case 1: return "end";
    case 2: return "end";
    case 3: return "corner";
    case 4: return "end";
    case 5: return "bridge";
    case 6: return "corner";
    case 7: return "T";
    case 8: return "end";
    case 9: return "corner";
    case 10: return "bridge";
    case 11: return "T";
    case 12: return "corner";
    case 13: return "T";
    case 14: return "T";
    case 15: return "intersection";
    default: return "";
    }

}

float getRotationFromIndex(int index) {
    switch (index) {
        case 2: return PI/2;
        case 4: return PI;
        case 6: return PI/2;
        case 8: return 3*PI/2;
        case 9: return -PI/2;
        case 10: return PI/2;
        case 11: return -PI/2;
        case 12: return PI;
        case 13: return PI;
        case 14: return PI/2;
        default: return 0.0;
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
            break;
        case "c":
            prevTiles = copyArray(tiles);
            tiles = new boolean[xNumTiles][yNumTiles];
        break;
        case "m":
            mirrored = !mirrored;
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
    renderTiles();
}

boolean[][] copyArray(boolean[][] matrix) {
    boolean[][] newArray = new boolean[matrix.length][];
    for (int i = 0; i < matrix.length; i++) {
        newArray[i] = matrix[i].clone();
    }
    return newArray;
}