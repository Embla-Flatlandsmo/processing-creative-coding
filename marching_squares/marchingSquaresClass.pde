class MarchingSquares {
    float values[][];
    float threshold;
    boolean inside[][];

    float tileSize;

    float xNumTiles;
    float yNumTiles;

    MarchingSquares(float tileSize, int xNumTiles, int yNumTiles) {
        this.xNumTiles = xNumTiles;
        this.yNumTiles = yNumTiles;
        this.tileSize = tileSize;
        this.values = new float[xNumTiles][yNumTiles];
        this.inside = new boolean[xNumTiles][yNumTiles];
        for (int x = 0; x < xNumTiles; x++) {
            for (int y = 0; y < yNumTiles; y++) {
                this.values[x][y]=noise(0.3*x, 0.3*y);
            }
        }
    }

    void setThreshold(float threshold) {
        this.threshold = threshold;
        this.calculateInsideOutsidePoints();
    }

    void calculateInsideOutsidePoints() {
        for (int x = 0; x < xNumTiles; x++) {
            for (int y = 0; y < yNumTiles; y++) {
                if (this.values[x][y] >= this.threshold) {
                    inside[x][y] = true;
                } else {
                    inside[x][y] = false;
                }
            }
        }
    }

    void drawLines() 
    {
        for (int x = 0; x < xNumTiles-1; x++) {
            for (int y = 0; y < yNumTiles-1; y++) {
                int configuration = 0;
                configuration += this.inside[x][y] ? 8 : 0;
                configuration += this.inside[x+1][y] ? 4 : 0;
                configuration += this.inside[x][y+1] ? 2 : 0;
                configuration += this.inside[x+1][y+1] ? 1 : 0;
                // String configuration = "";
                // configuration.append(this.inside[x][y] ? "1" : "0");
                // configuration.append(this.inside[x+1][y] ? "1" : "0");
                // configuration.append(this.inside[x][y+1] ? "1" : "0");
                // configuration.append(this.inside[x+1][y+1] ? "1" : "0");
                PVector top_left = new PVector((x+0.5)*tileSize, (y+0.5)*tileSize);
                drawLineFromConfiguration(top_left, configuration);
            }
        }
    }



    void drawLineFromConfiguration(PVector top_left, int configuration)
    {
        PVector a = new PVector(top_left.x + this.tileSize*0.5, top_left.y);
        PVector b = new PVector(top_left.x + this.tileSize,     top_left.y + this.tileSize*0.5);
        PVector c = new PVector(top_left.x + this.tileSize*0.5, top_left.y + this.tileSize);
        PVector d = new PVector(top_left.x               , top_left.y + this.tileSize*0.5);


        stroke(255);
        strokeWeight(2);
        switch(configuration) {
            case 0: // All outside
                break;
            case 1: // Bottom right inside
                drawSingleLine(b, c);
                break;
            case 2: // Bottom left inside
                drawSingleLine(c, d);
                break;
            case 3: // Bottom inside
                drawSingleLine(b, d);
                break;
            case 4: // Top right inside
                drawSingleLine(a, b);
                break;
            case 5: // Right side inside
                drawSingleLine(a,c);
                break;
            case 6: // Top right, bottom left
                drawSingleLine(a,b);
                drawSingleLine(d,c);
                break;
            case 7: // Three corners
                drawSingleLine(a,d);
                break;
            case 8: // Top left
                drawSingleLine(a,d);
                break;
            case 9: // Top left, bottom right
                drawSingleLine(a, d);
                drawSingleLine(b, c);
                break;
            case 10: // Left side
                drawSingleLine(a, c);
                break;
            case 11: // Three inside
                drawSingleLine(a, b);
                break;
            case 12: // Top inside
                drawSingleLine(b, d);
                break;
            case 13: 
                drawSingleLine(c,d);
                break;
            case 14:
                drawSingleLine(c, b);
                break;
            case 15: // All inside
                break;
        }



        // switch(configuration) {
        //     case "0000": // All outside
        //         break;
        //     case "0001": // Bottom right inside
        //         drawSingleLine(b, c);
        //         break;
        //     case "0010": // Bottom left inside
        //         drawSingleLine(c, d)
        //         break;
        //     case "0011": // Bottom inside
        //         drawSingleLine(b, d)
        //         break;
        //     case "0100": // Top right inside
        //         drawSingleLine(a, b);
        //         break;
        //     case "0101": // Right side inside
        //         drawSingleLine(a,c);
        //         break;
        //     case "0110": // Top right, bottom left
        //         drawSingleLine(a,b);
        //         drawSingleLine(d,c);
        //         break;
        //     case "0111": // Three corners
        //         drawSingleLine(a,d);
        //         break;
        //     case "1000": // Top left
        //         drawSingleLine(a,d);
        //         break;
        //     case "1001": // Top left, bottom right
        //         drawSingleLine(a, d);
        //         drawSingleLine(b, c);
        //         break;
        //     case "1010": // Left side
        //         drawSingleLine(a, c);
        //         break;
        //     case "1011": // Three inside
        //         drawSingleLine(a, b);
        //         break;
        //     case "1100": // Top inside
        //         drawSingleLine(b, d);
        //         break;
        //     case "1101": 
        //         drawSingleLine(c,d);
        //         break;
        //     case "1111": // All inside
        //     break;
        // }
    }

    void draw() {
        noStroke();
        for (int x = 0; x < xNumTiles; x++) {
            for (int y = 0; y < yNumTiles; y++) {
                fill(this.values[x][y]*255);
                ellipse((x+0.5)*tileSize, (y+0.5)*tileSize, 5, 5);
                // rect(floor(x*cellWidth), floor(y*cellHeight), ceil(cellWidth), ceil(cellHeight));
            }
        }
    }
}

void drawSingleLine(PVector p1, PVector p2)
{
    line(p1.x, p1.y, p2.x, p2.y);
}