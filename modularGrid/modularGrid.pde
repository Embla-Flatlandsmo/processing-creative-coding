/**
 * Based on Gestaltung P.2.3.6
 */
import processing.svg.*;

TileGrid modularGrid;
SettingsLoader settings;

boolean isDragged = false;

void settings() {
    settings = new SettingsLoader();
    int width = (int)round(settings.tileSize*settings.xNumTiles);
    int height = (int)round(settings.tileSize*settings.yNumTiles);

    size(width, height);
}

void setup() {
    modularGrid = new TileGrid(settings.tileSize, settings.xNumTiles, settings.yNumTiles);
    if (settings.templateExists) {
        modularGrid.setFromTemplate(settings.templateImage);
    }
}

void draw(){
    background(255);
    if (mousePressed) {
        if (!isDragged) modularGrid.setPrevGrid();
        if (mouseButton == LEFT) modularGrid.setAtMouseLoc(true);
        if (mouseButton == RIGHT) modularGrid.setAtMouseLoc(false);
        isDragged = true;
    } else {
        isDragged = false;
    }
    modularGrid.display();
}

void keyPressed() {
    if (key == 26) {
        //ctrl-Z
        println("ctrl-Z");
        modularGrid.undo();
    }
    switch (str(key).toLowerCase()) {
        case "r":
            modularGrid.reflect();
            break;
        case "c":
            modularGrid.clear();
            break;
        case "m":
            modularGrid.toggleMirrorMode();
            break;
        case "l":
            if (settings.templateExists) {
                modularGrid.setFromTemplate(settings.templateImage);
            }
            break;
        case "s":
            modularGrid.export();
            break;
        case "p":
            modularGrid.toggleDebugMode();
            break;
        case "v":
            modularGrid.refreshValueMap();
            break;
        default:
        break;
    }
}