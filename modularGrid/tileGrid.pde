class TileGrid extends InfoGrid {
    ArrayList<PShape> modules;
    boolean debugMode;

    TileGrid(float tileSize, int xNumTiles, int yNumTiles) {
        super(tileSize, xNumTiles, yNumTiles);
        modules = new ArrayList<PShape>();
        // The files must be in the data folder
        // of the current sketch to load successfully
        for (int i=0; i < 16; i++) {
            String shapeName = nf(i,2)+".svg";
            PShape shape = loadShape(shapeName);
            modules.add(shape);
        }
    }

    void toggleDebugMode() {
        debugMode = !debugMode;
    }

    void display() {
        if (debugMode) {
            super.display();
            return;
        }
        for (int xTile = 0; xTile < super.xNumTiles; xTile++) {
            for (int yTile = 0; yTile < super.yNumTiles; yTile++) {
                if (super.isActive(xTile,yTile)) {
                    int posX = (int)round(tileSize*xTile);
                    int posY = (int)round(tileSize*yTile);  
                    shape(modules.get(super.getAdjacencyIndex(xTile,yTile)), posX, posY, tileSize, tileSize);
                }
            }
        }
    }

    void export() {
        if (debugMode) {
            super.export();
            return;
        }
        // Note that #### will be replaced with the frame number. Fancy!
        beginRecord(SVG, "frame-####.svg");
        this.display();
        endRecord();
    }
}