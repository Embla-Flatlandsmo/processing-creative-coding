/**
 * Based on Gestaltung P.2.3.6
 */
import processing.svg.*;

ArrayList<PShape> modules;

void setup() {
  modules = new ArrayList<PShape>();
  // The files must be in the data folder
  // of the current sketch to load successfully
  PShape shape = loadShape("14.svg");
  modules.add(shape);
  try {
    PShape shape2 = loadShape("15.svg");
  } catch (NullPointerException e) {
    println("Could not load shape!");
  }
  size(400,400);
}


void draw(){
    shapeMode(CENTER);
    PShape tile = modules.get(0);

    // shape(tile, 0, 0, tile.width, tile.height);

    //Rotated 90 deg
    pushMatrix();
    translate(tile.width/2, tile.height/2);
    rotate(radians(90));
    shape(tile, 0, 0, tile.width, tile.height);
    popMatrix();

    //Next: Place on tile next to it, rotated 180 deg
    pushMatrix();
    translate(tile.width*3/2, tile.height/2);
    rotate(radians(90*3));
    shape(tile, 0, 0, tile.width, tile.height);
    popMatrix();

    pushMatrix();
    translate(tile.width*3/2, tile.height*3/2);
    rotate(radians(90));
    shape(tile, 0, 0, tile.width, tile.height);
    popMatrix();
}