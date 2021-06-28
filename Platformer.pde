/** Experimenting with the creation of a platformer, using processing (processing.org).
 @author Pieter Beernink
 @version 1.0
 @since 1.0
 */

final static float MOVE_SPEED = 5; // 5 pixel per frame


// declare global variables
Sprite sprite;

// setup initial window
void setup() {
    size(800, 600);
    sprite = new Sprite("data/dj.png", 1.0, 100, 300);
    sprite.change_x = 0; // give image an initial velocity to move
    sprite.change_y = 0; // give image an initial velocity to move
}

// draws on screen (60 fps) 
void draw() {
    background(255); // drawing white blackground
    
    sprite.display();
    sprite.update(); 
}

// called when a key is pressed, initializes sprite movement
void keyPressed(){
  if(keyCode == RIGHT) {
    sprite.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT) {
    sprite.change_x = -MOVE_SPEED;
  }
  else if(keyCode == UP) {
    sprite.change_y = -MOVE_SPEED;
  }
  else if(keyCode == DOWN) {
    sprite.change_y = MOVE_SPEED;
  }
}

// called when a key is released, stops sprite movement
void keyReleased(){
    if(keyCode == RIGHT) {
    sprite.change_x = 0;
  }
  else if(keyCode == LEFT) {
    sprite.change_x = 0;
  }
  else if(keyCode == UP) {
    sprite.change_y = 0;
  }
  else if(keyCode == DOWN) {
    sprite.change_y = 0;
  }

}
