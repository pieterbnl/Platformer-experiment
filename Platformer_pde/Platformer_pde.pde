PImage img;

void setup() {
    size(800, 600);
    img = loadImage("data/dj.png"); // initializing image
}

void draw() {
    background(255); // drawing white blackground
    image(img, 100, 300); // draw image
}
