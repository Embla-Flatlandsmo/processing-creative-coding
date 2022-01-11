class GrassField {
    private int numRows;
    private float fieldHeight;
    private ArrayList<GrassRow> rows;
    private ArrayList<PShape> possibleShapes;


    GrassField(int numGrassRows, float fieldHeight) {
        numRows = numGrassRows;
        this.fieldHeight = fieldHeight; 
        rows = new ArrayList<GrassRow>();
        possibleShapes = loadGrass();

        this.generateRows();
    }

    void display() {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.display();
        }
    }

    void createNewField() {
        rows.clear();
        this.generateRows();
    }

    void setNoiseMapScale(float noiseMapScale) {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.setNoiseMapScale(noiseMapScale);
        }
    }

    void incrementNoiseMapScale(float amount) {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.incrementNoiseMapScale(amount);
            rows.set(i, gr);
        }
    }

    void setRotationAmount(float rotationAmount) {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.setRotationAmount(rotationAmount);
            rows.set(i, gr);
        }
    }

    void incrementRotationAmount(float amount) {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.incrementRotationAmount(amount);
            rows.set(i, gr);
        }
    }

    void incrementNumGrass() {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.incrementNumGrass(numRows-i, possibleShapes);
            rows.set(i, gr);
        }
    }

    void decrementNumGrass() {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.decrementNumGrass(numRows-i, possibleShapes);
            rows.set(i, gr);
        }
    }

    void animateGrass(float progress) {
        for (int i = 0; i < numRows; i++) {
            GrassRow gr = rows.get(i);
            gr.animateGrass(progress);
            rows.set(i, gr);
        }
    }

    private void generateRows() {
        for (int i = 0; i < numRows; i++) {
            PVector startPos = new PVector(
                0, 
                map2(i, 0, numRows-1, height-fieldHeight, height-fieldHeight/5, LINEAR, EASE_IN)
            );
            GrassRow gr = new GrassRow(30, lerp(0.6, 1.5, (float)i/numRows), startPos, possibleShapes);
            rows.add(gr);
        }
    }
}

class GrassRow {
    private ArrayList<Grass> grassSequence;
    private PVector startPos;
    private float grassScale;
    private float noiseMapScale;
    private float rotationAmount;
    private int numGrass;

    GrassRow(int numGrass, float grassScale, PVector origin, ArrayList<PShape> possibleShapes) {
        this.numGrass= numGrass;
        this.grassScale = grassScale;
        grassSequence = new ArrayList<Grass>();
        startPos = origin.copy();
        noiseMapScale = 0.03;
        rotationAmount = PI/2;
        this.generateGrassSequence(possibleShapes);
    }

    void incrementRotationAmount(float rot) {
        this.setRotationAmount(rotationAmount + rot);
    }

    void setRotationAmount(float rot) {
        rotationAmount = rot;
        println("rotationAmount: "+rotationAmount);
        for (int i = 0; i < numGrass; i++) {
            Grass g = grassSequence.get(i);
            PVector pos = g.getPosition();
            g.setRotation(rotationAmount*(0.5-noise(noiseMapScale*pos.x, noiseMapScale*pos.y)));
            grassSequence.set(i, g);
        }
    }

    void incrementNoiseMapScale(float scale) {
        this.setNoiseMapScale(noiseMapScale + scale);
    }

    void setNoiseMapScale(float scale) {
        noiseMapScale = scale;
        println("noiseMapScale: "+noiseMapScale);
        for (int i = 0; i < numGrass; i++) {
            Grass g = grassSequence.get(i);
            PVector pos = g.getPosition();
            g.setRotation(rotationAmount*(0.5-noise(noiseMapScale*pos.x, noiseMapScale*pos.y)));
            g.setScale(lerp(0.8*grassScale,grassScale,noise(noiseMapScale*(pos.x+pos.y))));
            grassSequence.set(i, g);
        }
    }

    void animateGrass(float progress) {
        for (int i = 0; i < numGrass; i++) {
            Grass g = grassSequence.get(i);
            PVector pos = g.getPosition();
            g.setRotation(rotationAmount*(0.5-noise(noiseMapScale*pos.x+cos(progress*TWO_PI), noiseMapScale*pos.y, sin(progress*TWO_PI))));
            grassSequence.set(i,g);
        }
    }

    void incrementNumGrass(int amount, ArrayList<PShape> possibleShapes) {
        if (amount < 0) {
            return;
        }
        numGrass = numGrass+amount;
        this.generateGrassSequence(possibleShapes);


    }

    void decrementNumGrass(int amount, ArrayList<PShape> possibleShapes) {
        if (amount < 0) {
            return;
        }
        numGrass = numGrass-amount > 0 ? numGrass-amount: 0;
        println("numGrass: "+numGrass);
        this.generateGrassSequence(possibleShapes);
        // if (amount < 0) {
        //     return;
        // }
        // numGrass = numGrass-amount > 0 ? numGrass-amount : 0;
        // int grassSequenceLength = grassSequence.size();
        // while ((grassSequenceLength > numGrass) || (grassSequenceLength > 0)) {
        //     grassSequence.remove(grassSequenceLength-1);
        //     grassSequenceLength--;
        // }
    }

    void generateGrassSequence(ArrayList<PShape> possibleShapes) {
        grassSequence.clear();
        for (int i = 0; i < numGrass; i++) {
            // PVector pos = new PVector(lerp(startPos.x, width, i/numGrass), startPos.y);
            PVector pos = new PVector(lerp(startPos.x, width, (float)i/numGrass), startPos.y);
            Grass g = new Grass(chooseRandom(possibleShapes), pos, rotationAmount*(0.5-noise(noiseMapScale*pos.x, noiseMapScale*pos.y)), lerp(0.8*grassScale,grassScale,noise(noiseMapScale*(pos.x+pos.y))));
            grassSequence.add(g);
        }
    }

    void display() {
        stroke(255);
        strokeWeight(3);
        fill(#6C0405);
        for (int i = 0; i < numGrass; i++) {

            Grass g = grassSequence.get(i);
            g.display();
        }
        //To fill out rows:
        rectMode(CORNERS);
        rect(startPos.x, startPos.y+10, width, height);

        noStroke();
        for (int i = 0; i < numGrass; i++) {
            Grass g = grassSequence.get(i);
            g.display();
        }
    }
}

class Grass {
    private PShape img;
    private float rot;
    private float scale;
    private PVector pos;

    Grass(PShape shape, PVector position, float rotation, float scale) {
        img = shape;
        shape.disableStyle();
        pos = position;
        rot = rotation;
        this.scale = scale;
    }

    PVector getPosition() {
        return pos.copy();
    }

    void setRotation(float rotation) {
        rot = rotation;
    }

    void setScale(float scale) {
        scale = scale;
    }

    void setShape(PShape shape) {
        img = shape;
    }

    void display() {
        if (scale == 0) {
            return;
        }
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rot);
        scale(scale);
        // stroke(1/scale);
        shape(img, -img.width/2, -img.height/2);
        popMatrix();
    }
}
// PShape grass00;
// PShape grass01;
// ArrayList<PShape> grassSequenceFront;
// int numGrassFront = 10;

// ArrayList<PShape> grassSequenceBack;
// int numGrassBack = 30;

// float rotationAmount = PI/10;
// float noiseMapScale = 0.01;

// void drawTransformedShape(PShape shape, float rot, float scale, PVector pos) {
//   pushMatrix();

//   translate(pos.x, pos.y);
//   ellipse(0, 0, 10, 10);
//   rotate(rot);
//   scale(scale);
//   shape(shape, -shape.width/2, -shape.height/2);
//   popMatrix();
// }

// PShape generateRandomGrass() {
//     if (random(1) > 0.5) {
//       return grass00;
//     } else {
//       return grass01;
//     }
// }

// ArrayList<PShape> generateGrassSequence(int numGrass) {
//   ArrayList<PShape> grassSequence = new ArrayList<PShape>();
//   for (int i = 0; i < numGrass; i++) {
//     grassSequence.add(generateRandomGrass());
//   }
//   return grassSequence;
// }

// void drawGrassRow(ArrayList<PShape> grassSequence, PVector startPos, float scale) {
//   strokeWeight(5);
//   stroke(0);
//   for (int i = 0; i < grassSequence.size(); i++) {
//     PVector pos = new PVector(startPos.x+i*width/grassSequence.size(), startPos.y);
//     drawTransformedShape(grassSequence.get(i), (0.5-noise(noiseMapScale*pos.x, noiseMapScale*pos.y))*rotationAmount, scale, pos);
//   }
//   fill(255);
//   noStroke();
//   for (int i = 0; i < grassSequence.size(); i++) {
//     PVector pos = new PVector(startPos.x+i*width/grassSequence.size(), startPos.y);
//     drawTransformedShape(grassSequence.get(i), (0.5-noise(noiseMapScale*pos.x, noiseMapScale*pos.y))*rotationAmount, scale, pos);
//   }
// }