class TileGrid extends InfoGrid {
    HashMap<String, ArrayList<PShape>> modules;

    int valueMap[][];
    int maxRandomValue;

    boolean debugMode;

    TileGrid(float tileSize, int xNumTiles, int yNumTiles) {
        super(tileSize, xNumTiles, yNumTiles);

        // Value map to keep track of which (random) tile to use
        maxRandomValue = 200;
        valueMap = new int[xNumTiles][yNumTiles];
        for (int x = 0; x < xNumTiles; x++) {
            for (int y = 0; y < yNumTiles; y++) {
                valueMap[x][y] = (int)random(maxRandomValue);
            }
        }

        modules = new HashMap<String, ArrayList<PShape>>();
        String[] moduleNames = { "island", "intersection", "end", "corner", "bridge", "T"};
        for (int i = 0; i < moduleNames.length; i++) {
            ArrayList<PShape> tiles = loadModules(moduleNames[i]);
            modules.put(moduleNames[i], tiles);
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
        shapeMode(CENTER);
        for (int xTile = 0; xTile < super.xNumTiles; xTile++) {
            for (int yTile = 0; yTile < super.yNumTiles; yTile++) {
                if (super.isActive(xTile,yTile)) {
                    int posX = (int)(tileSize+0.5)*xTile;
                    int posY = (int)(tileSize+0.5)*yTile;
                     
                    int adjacencyIndex = super.getAdjacencyIndex(xTile, yTile); 
                    String moduleName = this.getKeyFromIndex(adjacencyIndex);
                    float rotation = this.getRotationFromIndex(adjacencyIndex);
                    ArrayList<PShape> possibleModules = modules.get(moduleName);
                    int randIndex = valueMap[xTile][yTile] % possibleModules.size();
                    PShape module = possibleModules.get(randIndex);
                    pushMatrix();
                    translate(posX, posY);
                    rotate(rotation);
                    shape(module, 0, 0, tileSize, tileSize);
                    popMatrix();
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

    private String getKeyFromIndex(int index) {
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

    private float getRotationFromIndex(int index) {
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
}