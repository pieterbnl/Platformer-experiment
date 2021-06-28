PImage img;
float center_x, center_y; // float is default type for processing
float change_x, change_y; // float is default type for processing

void setup() {
    size(800, 600);
    img = loadImage("data/dj.png"); // initializing image
    center_x = 100;
    center_y = 300;
    change_x = 5;
    change_y = 2;
}

void draw() {
    background(255); // drawing white blackground
    image(img, center_x, center_y); // draw image
    center_x += change_x; // update position of object
    center_y += change_y; 
}
