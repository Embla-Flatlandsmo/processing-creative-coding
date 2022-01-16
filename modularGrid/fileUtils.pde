
/**
    Imports a PNG sequence with the given filename. 
    Note that the PNG sequence must be zero-indexed with 3 significant figures
*/
PImage[] importPNGSequence(String filename, int sequenceLength) {
    PImage[] images = new PImage[sequenceLength];
    for (int i = 0; i < sequenceLength; i++) {
        String imageFile = filename + nf(i, 3) + ".png";
        images[i] = loadImage(imageFile);
    }
    return images;
}

ArrayList<PShape> loadModules(String tileName) {
    ArrayList<PShape> tiles = new ArrayList<PShape>();
    int i = 0;
    while (true) {
        try {
            String shapeName = tileName + "_" + nf(i, 2) + ".svg";
            PShape shape = loadShape(shapeName);
            tiles.add(shape);
            i++;
            println("Added shape: " + shapeName);
        }
        catch (NullPointerException e) {
            break;
        }
    }
    return tiles;
}