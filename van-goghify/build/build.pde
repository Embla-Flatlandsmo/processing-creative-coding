ArrayList<String> imgNames;
ArrayList<PImage> imgs;
int imgIndex;
float noiseMapScale = 0.005;
float lineWidthStart = 10;
float lineWidth;

void setup() {
	lineWidth = lineWidthStart;
	frameRate(5000);
	rectMode(CENTER);
	imgIndex = -1;
	//initialize arraylists
	imgNames = new ArrayList<String>();
	imgs = new ArrayList<PImage>();



	imgNames.add("OmBul_jul.png");
	imgNames.add("OmBul_paaske.png");
	for (int i = 0; i < imgNames.size(); i++) {
		imgs.add(loadImage(imgNames.get(i)));
	}
	size(800,600);
	background(0);
	changeImage();
}

void draw() {
	PImage img = imgs.get(imgIndex);

	int x = int(random(img.width));
	int y = int(random(img.height));

	float angle = TWO_PI*noise(noiseMapScale*x,noiseMapScale*y);


	int index = (y*img.width + x);
	stroke(img.pixels[index]);
	strokeWeight(lineWidth);

	pushMatrix();
	translate(
		x,
		y
		);

	rotate(angle);

	rect(0,0,20,0);

	popMatrix();
	if ((frameCount%1000 == 0) && lineWidth != 1) {
		lineWidth -= 1;
	}

}

void changeImage() {
	lineWidth = lineWidthStart;
	imgIndex++;
	if (imgIndex >= imgNames.size()) {
		imgIndex = 0;
	}

	imgs.get(imgIndex).loadPixels();
}

void mousePressed() {
	changeImage();
}