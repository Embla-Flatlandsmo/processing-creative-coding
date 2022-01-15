class InfoGrid {
    boolean tiles[][];
    boolean prevTiles[][]; // for one-step ctrl-z
    int yNumTiles;
    int xNumTiles;
    float tileSize;

    boolean templateExists;

    InfoGrid(float tileSize, int xNumTiles, int yNumTiles) {
        this.xNumTiles = xNumTiles;
        this.yNumTiles = yNumTiles;
        this.tileSize = tileSize;
        tiles = new boolean[xNumTiles][yNumTiles];
        prevTiles = new boolean[xNumTiles][yNumTiles];
        templateExists = false;
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

    boolean get(int x, int y) {
        return tiles[x][y];
    }

    void set(int x, int y, boolean on) {
        tiles[x][y] = on;
    }

    void setAtMouseLoc(boolean on) {
        int xTile = floor(mouseX / tileSize);
        xTile = constrain(xTile, 0, xNumTiles-1);
        int yTile = floor(mouseY / tileSize);
        yTile = constrain(yTile, 0, yNumTiles-1);
        // int xTile = (int)constrain(floor(mouseX/tileSize), 0, xNumTiles-1);
        // int yTile = (int)constrian(floor(mouseY/tileSize), 0, yNumTiles-1);
        tiles[xTile][yTile] = on;
    }

    void setPrevGrid() {
        prevTiles = copyArray(tiles);
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

    void export() {
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


    void display() {
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

}

boolean[][] copyArray(boolean[][] matrix) {
    boolean[][] newArray = new boolean[matrix.length][];
    for (int i = 0; i < matrix.length; i++) {
        newArray[i] = matrix[i].clone();
    }
    return newArray;
}