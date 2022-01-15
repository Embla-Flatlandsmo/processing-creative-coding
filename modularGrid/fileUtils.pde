
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

PImage importTemplateImage(String templateName) {
    PImage templateImage = loadImage(templateName);
    if (templateImage == null) return templateImage;
    templateImage.loadPixels();
    if (templateImage.width == -1 || templateImage.height == -1) return templateImage;

    color threshold = #808080;
    templateImage.filter(THRESHOLD);
    
    // width = templateImage.width;
    // height = templateImage.height;
    // xNumTiles = width;
    // yNumTiles = height;
    // templateExists = true;
    return templateImage;
}