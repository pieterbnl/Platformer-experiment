/** Experimenting with the creation of a platformer, using processing (processing.org).
 @author Pieter Beernink
 @version 1.0
 @since 1.0
 */

final static float MOVE_SPEED = 5; // 5 pixel per frame
final static float SPRITE_SCALE = 50.0/128; // scaling original image of 128 pixels to 50 pixels
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 14;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

// declare global variables
Sprite player; // sprite for player
// PImage snow, crate, red_brick, brown_brick;
PImage tile, crate, red_brick, brown_brick, coin;
ArrayList<Sprite> platform; // array list for all platform sprites
ArrayList<Sprite> coins; // array list for all coin sprites

// setup initial window
void setup() {
    size(1500, 600);
    imageMode(CENTER); // set's sprite center to center
    
    player = new Sprite("data/player.png", 1.0, 600, 600);
    player.change_x = 0; // give player a standard velocity in x direction
    player.change_y = -10; // give player a standard velocity in y direction (i.e.: gravity)
    
    platform = new ArrayList<Sprite>(); // initialize array that will hold all sprites to generate the platform
    coins = new ArrayList<Sprite>(); // initialize array that will hold all coin sprites - note its initialized as Sprite, but can hold any subclasses
    
    coin = loadImage("data/gold1.png");
    red_brick = loadImage("data/red_brick.png");
    brown_brick = loadImage("data/brown_brick.png");
    crate = loadImage("data/crate.png");
    // snow = loadImage("data/snow.png");
    tile = loadImage("tile.png");
    createPlatform("data/map.csv"); // create platform with all images according the configuration as set in the map.csv file
}

// draws on screen (60 fps) 
void draw() {
  background(255); // drawing white blackground
  
  player.display(); // draw player sprite
   
  // player.update();  // update player sprite position
  resolvePlatformCollisions(player, platform);
   
  // draw platform
  for(Sprite s: platform) 
    s.display();
    
  // draw coins
  for(Sprite c: coins) { // draw platform
    c.display(); // display coin
    ((AnimatedSprite)c).updateAnimation(); // need to cast down to be able to call updateAnimation to animate the coin
  }
}


// jumping method - returns whether the sprite is on one of the platform
// note: player can only jump when he is on platform and there's no multi-jumping
public boolean isOnPlatform(Sprite s, ArrayList<Sprite> walls) {
  s.center_y += 5; // move sprite 5 pixels down (note: y is inverted, hence +)
  ArrayList<Sprite> col_list = checkCollisionList(s, walls); // check for collisions: computer collision list with platform
  s.center_y -= 5; // restore sprite original position by moving 5 pixels up again
  if(col_list.size() > 0) { // if collision list is not empty, return true, otherwise return false 
    return true;
  } else {
    return false;
  }
}

// resolve collisions between sprites (for example: between the player sprite and platform sprites)
// doing so by first moving into vertical (=gravity) direction and resolving any collisions
// then by moving in horizontal direction and resolving any collisions
public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {
  
  // add gravity to change_y
  s.change_y += GRAVITY;
  
  // move in y-direction
  s.center_y += s.change_y;
  
  // then resolve collision in y direction by computing list and fixing the collision
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if(col_list.size() >0) { // if col_list is larger, then there has been a collision and we'll look only at the first item because all sprites allign nicely
    Sprite collided = col_list.get(0);
    if(s.change_y > 0) { // meaning falling down - need to set bottom of player equal to top of the colliding sprite 
      s.setBottom(collided.getTop());
    }
    else if (s.change_y < 0) { // meaning jumping up - set the top of player to be equal to the bottom of the colliding sprite
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }
  
  
  // move in x-direction
  s.center_x += s.change_x;
  
  // then resolve collision in x direction by computing list and fixing the collision
  col_list = checkCollisionList(s, walls); // can re-use earlier on initialized array
  if(col_list.size() >0) { // if col_list is larger, then there has been a collision and we'll look only at the first item because all sprites allign nicely
    Sprite collided = col_list.get(0);
    if(s.change_x > 0) { // meaning going right - need to set right side of player equal to the left side of the colliding sprite 
      s.setRight(collided.getLeft());
    }
    else if (s.change_x < 0) { // meaning going left - need to set left side of player equal to the right side of the colliding sprite
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
}


// method for collision detection; takes 2 sprites and compares their relative positions
// detecting when sprites are NOT colliding:
// Case 1: s l's right < s2's left
// Case 2: s l's left > s2's right
// Case 3: s l's bottom < s2's top
// Case 4: s l's top < s2's bottom

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else { // both directions do overlap
    return true;
  }
}

// Given a sprite and an ArrayList of sprites, return an ArrayList of sprites which collides with the given sprite.
// A list is used because it's possible that a collision takes place with multiple sprites.
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

// takes filename and create platform
void createPlatform(String filename) {
  String[] lines = loadStrings(filename); // takes css file and loads into an array (lines), with first element representing the entire first row of the css file which is a String
  
  for(int row = 0; row < lines.length; row++) { // loop through each element
    String[] values = split(lines[row], ","); // split the values in the String in the element, to extract each individual value, which are returned in another array (values)
    for(int col = 0; col < values.length; col++) { // loop through the values
      if(values[col].equals("1")) { // check what each value equals with
        Sprite s = new Sprite(red_brick, SPRITE_SCALE); // calling Sprite constructor to load the image (only once) and scale it
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE; // set x positioning of the image
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE; // set y positioning of the image
        platform.add(s); // add to an arraylist of sprites
      } 
      else if(values[col].equals("2")) {
        Sprite s = new Sprite(tile, SPRITE_SCALE);
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
       else if(values[col].equals("5")) { // create a coin
        Coin c = new Coin(coin, SPRITE_SCALE);
        c.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        c.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(c); // add to coins array list
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
  //else if(keyCode == UP) {
  //  player.change_y = -MOVE_SPEED;
  //}
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
  else if(key == 'a' && isOnPlatform(player, platform)) {; // if jump key is pressed AND sprite is on platform: sprite.change_y = -JUMP_SPEED
    player.change_y = -JUMP_SPEED;
  }
  //else if(keyCode == UP) {
  //  player.change_y = 0;
  //}
  else if(keyCode == DOWN) {
    player.change_y = 0;
  }
  
}
