void drawTransformedShape(PShape shape, float rot, float scale, PVector pos) {
  pushMatrix();
  translate(pos.x, pos.y);
  rotate(rot);
  scale(scale);
  shape(shape, -shape.width/2, -shape.height/2);
  popMatrix();
}

ArrayList<PShape> loadGrass() {
    // The files must be in the data folder
    // of the current sketch to load successfully
    ArrayList<PShape> grass = new ArrayList<PShape>();
    for (int i=0; i < 2; i++) {
        String num;
        if (i < 10) {
            num = "0"+str(i);
        } else {
            num = str(i);
        }
        PShape shape;
        try { 
            shape = loadShape("grass-"+num+".svg"); 
            shape.disableStyle();
            println("Loaded grass-"+num);
        }
        catch (NullPointerException e) {
            return grass;
        }
        grass.add(shape);
    }
    return grass;
}

PShape chooseRandom(ArrayList<PShape> possibleShapes) {
    return possibleShapes.get((int)random(possibleShapes.size()));
}