// enum Neighbor {
//     NORTH = 8,
//     WEST = 4,
//     SOUTH = 2,
//     EAST = 1
// };

// enum TileStatus {
//     ACTIVE = unbinary("10000000"),
//     INACTIVE = 0
// };


// TODO: Bytes for space efficiency?
static int ACTIVE_TILE_MASK = 1 << 8;

// Enums don't seem to work so this will do
static abstract class Neighbor {
  static final int NEIGHBORS_MASK = unbinary("1111");
  static final int NORTH_BIT = 3;
  static final int WEST_BIT = 2;
  static final int SOUTH_BIT = 1;
  static final int EAST_BIT = 0;
//   static final int NORTH = 1 << NORTH_BIT; // 8
//   static final int WEST = 1 << 3; // 4
//   static final int SOUTH = 1 << 2; // 2
//   static final int EAST = 1;
}


class InfoGrid {
    int tiles[][];
    int prevTiles[][]; // for one-step ctrl-z
    int yNumTiles;
    int xNumTiles;
    float tileSize;

    boolean mirrorMode;

    InfoGrid(float tileSize, int xNumTiles, int yNumTiles) {
        this.xNumTiles = xNumTiles;
        this.yNumTiles = yNumTiles;
        this.tileSize = tileSize;
        tiles = new int[xNumTiles][yNumTiles];
        prevTiles = new int[xNumTiles][yNumTiles];
        mirrorMode = false;
    }

    boolean isActive(int x, int y) {
        return boolean(tiles[x][y] & ACTIVE_TILE_MASK);
    }

    int getAdjacencyIndex(int x, int y) {
        return tiles[x][y] & Neighbor.NEIGHBORS_MASK;
    }

    void set(int x, int y, boolean on) {
        if (on) {
            tiles[x][y] |= ACTIVE_TILE_MASK;
            if (mirrorMode) tiles[xNumTiles-x-1][y] |= ACTIVE_TILE_MASK;
        } else {
            tiles[x][y] &= ~ACTIVE_TILE_MASK;
            if (mirrorMode) tiles[xNumTiles-x-1][y] &= ~ACTIVE_TILE_MASK;
        }
        this.setAdjacentTiles(x, y, on);
        if (mirrorMode) this.setAdjacentTiles(xNumTiles-x-1, y, on);
    }

    void setAtMouseLoc(boolean on) {
        int xTile = floor(mouseX / tileSize);
        xTile = constrain(xTile, 0, xNumTiles-1);
        int yTile = floor(mouseY / tileSize);
        yTile = constrain(yTile, 0, yNumTiles-1);
        // int xTile = (int)constrain(floor(mouseX/tileSize), 0, xNumTiles-1);
        // int yTile = (int)constrian(floor(mouseY/tileSize), 0, yNumTiles-1);
        this.set(xTile, yTile, on);
    }

    void setPrevGrid() {
        prevTiles = copyArray(tiles);
    }

    void reflect() {
        for (int xTile = 0; xTile < xNumTiles-1; xTile++) {
            for (int yTile = 0; yTile<yNumTiles-1; yTile++) {
                if ((this.isActive(xTile, yTile)) || (this.isActive(xNumTiles-xTile-1, yTile))) {
                    this.set(xNumTiles-xTile-1, yTile, true);
                    this.set(xTile, yTile, true);
                }
            }
        }
    }

    void setFromTemplate(PImage templateImage) {
        if (xNumTiles != templateImage.width || yNumTiles != templateImage.height) {
            xNumTiles = templateImage.width;
            yNumTiles = templateImage.height;
            tiles = new int[xNumTiles][yNumTiles];
            prevTiles = copyArray(tiles);
        }
        
        for (int x = 0; x < xNumTiles; x++) {
            for (int y = 0; y < yNumTiles; y++) {
                if (templateImage.pixels[y*templateImage.width+x] == #000000) {
                    this.set(x,y,true);
                } else {
                    this.set(x,y,false);
                }
            }
        }
    }

    void undo() {
        int tmpTiles[][] = copyArray(tiles);
        tiles = copyArray(prevTiles);
        prevTiles = copyArray(tmpTiles);
    }

    void clear() {
        tiles = new int[xNumTiles][yNumTiles];
        prevTiles = new int[xNumTiles][yNumTiles];
    }

    void toggleMirrorMode() {
        mirrorMode = !mirrorMode;
    }

    private void setAdjacentTiles(int xTile, int yTile, boolean on) {
        if (yTile > 0) { // Neighbor in the north, we inform them about our existence to their south
            if (on) {
                tiles[xTile][yTile-1] |= (1 << Neighbor.SOUTH_BIT);
            } else {
                tiles[xTile][yTile-1] &= ~(1 << Neighbor.SOUTH_BIT);
            }
        }

        if (yTile < yNumTiles-1) { // Neighbor in the south
            if (on) {
                tiles[xTile][yTile+1] |= (1 << Neighbor.NORTH_BIT);
            } else {
                tiles[xTile][yTile+1] &= ~(1 << Neighbor.NORTH_BIT);
            }
        }

        if (xTile > 0) { //Neighbor to the west
            if (on) {
                tiles[xTile-1][yTile] |= (1 << Neighbor.EAST_BIT);
            } else {
                tiles[xTile-1][yTile] &= ~(1 << Neighbor.EAST_BIT);
            }
        }
        
        if (xTile < xNumTiles-1) { // Neighbor to the east
            if (on) {
                tiles[xTile+1][yTile] |= (1 << Neighbor.WEST_BIT);
            } else {
                tiles[xTile+1][yTile] &= ~(1 << Neighbor.WEST_BIT);
            }
        }
    }

    void export() {
        PImage image = createImage(xNumTiles, yNumTiles, RGB);
        color black = color(0);
        color white = color(255);
        for (int xTile=0; xTile<xNumTiles; xTile++) {
            for (int yTile=0; yTile<yNumTiles; yTile++) {
                if (boolean(tiles[xTile][yTile] & ACTIVE_TILE_MASK)) {
                    image.pixels[yTile*xNumTiles+xTile] = black;
                } else {
                    image.pixels[yTile*xNumTiles+xTile] = white;
                }
            }
        } 
        image.save("pixelMap.png");
    }

    void display() {
        fill(0);
        for (int xTile=0; xTile<xNumTiles; xTile++) {
            for (int yTile=0; yTile<yNumTiles; yTile++) {
                if (boolean(tiles[xTile][yTile] & ACTIVE_TILE_MASK)) {
                    int posX = (int)round(tileSize*xTile);
                    int posY = (int)round(tileSize*yTile); 
                    rect(posX, posY, tileSize, tileSize);
                }
            }
        } 
    }

}

int[][] copyArray(int[][] matrix) {
    int[][] newArray = new int[matrix.length][];
    for (int i = 0; i < matrix.length; i++) {
        newArray[i] = matrix[i].clone();
    }
    return newArray;
}

// boolean[][] copyArray(boolean[][] matrix) {
//     boolean[][] newArray = new boolean[matrix.length][];
//     for (int i = 0; i < matrix.length; i++) {
//         newArray[i] = matrix[i].clone();
//     }
//     return newArray;
// }