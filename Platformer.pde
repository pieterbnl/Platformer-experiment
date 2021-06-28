/** Experimenting with the creation of a platformer, using processing (processing.org).
 @author Pieter Beernink
 @version 1.0
 @since 1.0
 */

final static float MOVE_SPEED = 5; // 5 pixel per frame
final static float SPRITE_SCALE = 50.0/128; // scaling original image of 128 pixels to 50 pixels
final static float SPRITE_SIZE = 50;


// declare global variables
Sprite player; // sprite for player
PImage snow, crate, red_brick, brown_brick;
ArrayList<Sprite> platform;

// setup initial window
void setup() {
    size(800, 600);
    player = new Sprite("data/player.png", 1.0, 100, 300);
    player.change_x = 0; // give image an initial velocity to move
    player.change_y = 0; // give image an initial velocity to move
    
    platform = new ArrayList<Sprite>(); // will hold all sprites to generate the platform
    
    red_brick = loadImage("data/red_brick.png");
    brown_brick = loadImage("data/brown_brick.png");
    crate = loadImage("data/crate.png");
    snow = loadImage("data/snow.png");
    createPlatform("data/map.csv"); // create platform with all images according the configuration as set in the map.csv file
}

// draws on screen (60 fps) 
void draw() {
    background(255); // drawing white blackground
    
    player.display(); // draw player sprite
    player.update();  // update player sprite position
    
    for(Sprite s: platform) // draw platform
      s.display();
}

// takes filename and create platform
void createPlatform(String filename) {
  String[] lines = loadStrings(filename); // takes css file and loads into an array (lines), with first element representing the entire first row of the css file which is a String
  
  for(int row = 0; row < lines.length; row++) 
  { // loop through each element
    String[] values = split(lines[row], ","); // split the values in the String in the element, to extract each individual value, which are returned in another array (values)
    
    for(int col = 0; col < values.length; col++) { // loop through the values
      if(values[col].equals("1")) { // check what each value equals with
        Sprite s = new Sprite(red_brick, SPRITE_SCALE); // calling Sprite constructor to load the image (only once) and scale it
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE; // set x positioning of the image
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE; // set y positioning of the image
        platform.add(s); // add to an arraylist of sprites
      } 
      else if(values[col].equals("2")) {
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platform.add(s);
      }
      else if(values[col].equals("3")) {
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platform.add(s);
      }
      else if(values[col].equals("4")) {
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platform.add(s);
      }
    }
   } 
}

// called when a key is pressed, initializes sprite movement
void keyPressed(){
  if(keyCode == RIGHT) {
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT) {
    player.change_x = -MOVE_SPEED;
  }
  else if(keyCode == UP) {
    player.change_y = -MOVE_SPEED;
  }
  else if(keyCode == DOWN) {
    player.change_y = MOVE_SPEED;
  }
}

// called when a key is released, stops sprite movement
void keyReleased(){
    if(keyCode == RIGHT) {
    player.change_x = 0;
  }
  else if(keyCode == LEFT) {
    player.change_x = 0;
  }
  else if(keyCode == UP) {
    player.change_y = 0;
  }
  else if(keyCode == DOWN) {
    player.change_y = 0;
  }

}
