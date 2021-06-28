/** Experimenting with the creation of a platformer, using processing (processing.org).
 @author Pieter Beernink
 @version 1.0
 @since 1.0
 */

// declare global variables
Sprite sprite;

// setup initial window
void setup() {
    size(800, 600);
    sprite = new Sprite("data/dj.png", 1.0, 100, 300);
    sprite.change_x = 5; // give image a velocity to move
}

// draws on screen (60 fps) 
void draw() {
    background(255); // drawing white blackground
    
    sprite.display();
    sprite.update(); 
}
