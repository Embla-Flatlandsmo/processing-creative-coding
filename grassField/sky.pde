// class Sky {
//     Sky(float noiseMap, )
// }


class FlowField {
    float angles[][];
    float noiseMapScale;

    int numRows;
    int numCols;

    FlowField(int numRows, int numCols, float noiseMapScale) {
        angles = new float[numCols][numRows];
        this.numRows = numRows;
        this.numCols = numCols;
        this.noiseMapScale = noiseMapScale;

        for (int x = 0; x < numCols; x++) {
            for (int y = 0; y < numRows; y++) {
                angles[x][y] = TWO_PI*(0.5-noise(noiseMapScale*x, noiseMapScale*y));
            }
        }
    }

    void restartFlowField() {
        noiseSeed((int)random(100));
        for (int x = 0; x < numCols; x++) {
            for (int y = 0; y < numRows; y++) {
                angles[x][y] = TWO_PI*(0.5-noise(noiseMapScale*x, noiseMapScale*y));
            }
        }
    }


    void display() {
        stroke(255);
        strokeWeight(1);
        noFill();
        float x = 0;
        float y = 0;
        for (int i = 0; i < 30; i++) {
            y = i*width/30;
            x = 0;
            beginShape();
            curveVertex(x,y);
            while ((0 < x && x < width) || (0 < y && y < height)) {
                curveVertex(x, y);
                int column_index = constrain((int)Math.floor(x/numRows), 0, numCols-1);
                int row_index = constrain((int)Math.floor(y/numCols), 0, numRows-1);
                x += 50*cos(angles[column_index][row_index]);
                y += 50*sin(angles[column_index][row_index]);
            }
            endShape();

        }
    }

}