/** Experimenting with the creation of a platformer 
following Long Nguyen (LongNguyen) computer science class course 
with use of processing (processing.org) 
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

final static float WIDTH = SPRITE_SIZE * 16; // width of window
final static float HEIGHT = SPRITE_SIZE * 12; // height of window
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;// set ground level of where player is standing

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

// declare global variables
Player player; // declaring player
PImage tile, crate, red_brick, brown_brick, coin, spider, p; 
ArrayList<Sprite> platform; // array list for all platform sprites
ArrayList<Sprite> coins; // array list for all coin sprites
Enemy enemy; // declaring enemy

// keep track if game is still ongoing
boolean isGameOver;

// set player's initial number of coins
int numCoins;

// variables to keep track of the top left corner of the visible part of the platform when the user is scrolling/moving
// when the player is moving, it's actually the platform that's moving and not the view
// the platform origin (0,0) is moved relatively to the view (view_x, view_y) point, using a 'translate' method
// to handle this, a boundary and margin is set
// as long as the player movies within the boundary, no scrolling is inititated
// as soon as the player crosses the boundary, into the margin, scrolling is initiated towards the player's direction
// as such compensating fro the player movement and ensuring he stays within the boundary
// if player leaves boundary: compute new view_x, view_y to maintain margin translate(-view_x, -view_y)
// right boundary = view_x + width - right margin
// bottom boundary = view_y + height - bottom margin
// note: text on the screen, such as score, needs to be moved relative to view_x and view_y as well to make sure it scroll's along with the player
float view_x; 
float view_y; 


// setup initial window
void setup() {
    size(800, 600); // set window size
    imageMode(CENTER); // sets sprite center to the center of the image
    
    // create player object
    PImage p = loadImage("player.png");
    player = new Player(p, 0.8); // create Player object with provision of player image (p) and scaling (0.8)
    player.center_x = 100;
    player.setBottom(GROUND_LEVEL); // set bottom of player to be on the bottom of ground level
           
    platform = new ArrayList<Sprite>(); // initialize array that will hold all sprites to generate the platform
    coins = new ArrayList<Sprite>(); // initialize array that will hold all coin sprites - note its initialized as Sprite, but can hold any subclasses
    numCoins = 0;
    isGameOver = false;
        
    // initialize inital sprites
    coin = loadImage("data/gold1.png");
    spider = loadImage("data/spider_walk_right1.png");
    red_brick = loadImage("data/red_brick.png");
    brown_brick = loadImage("data/brown_brick.png");
    crate = loadImage("data/crate.png");
    // snow = loadImage("data/snow.png");
    tile = loadImage("tile.png");
    
    // create platform level with all images according the configuration as set in the map.csv file
    createPlatform("data/map.csv");
    
    view_x = 0; 
    view_y = 0;
}

// draws on screen (60 fps) 
void draw() {
  background(255); // drawing white blackground  
  scroll(); // needs to be first method to be called
  
  // display all objects
  displayAll(); 
  
  // update all objects (if game is not over)
  if(!isGameOver) {
    updateAll(); 
    collectCoins();
    checkDeath();
  }
}

void displayAll() {
  // draw/display platform
  for(Sprite s: platform) 
    s.display();
    
  // draw/display coins
  for(Sprite c: coins) {
    c.display();
  }
  
  // display player & enemy sprite
  player.display();
  enemy.display();
  
  // present player coin score & lives 
  fill(255, 0, 0);
  textSize(32);
  text("Coin:" + numCoins, view_x + 50, view_y + 50);
  text("Lives:" + player.lives, view_x + 50, view_y + 100);
  
  if(isGameOver) {
    fill(0,0,255);
    text("GAME OVER!", view_x + width/2 - 100, view_y + height/2);
    if(player.lives == 0)
      text("You lose!", view_x + width/2 - 100, view_y + height/2 + 50);
    else
      text("You win!", view_x + width/2 - 100, view_y + height/2 + 50);
    text("Press SPACE to restart", view_x + width/2 - 100, view_y + height/2 + 100);
  }   
}

// update objects
void updateAll() {
  player.updateAnimation(); // animate player's sprite
  resolvePlatformCollisions(player, platform);
  enemy.update(); // updates enemy's sprite position
  enemy.updateAnimation(); // animate enemy's sprite
  
  // draw coins
  for(Sprite c: coins) { 
    ((AnimatedSprite)c).updateAnimation(); // need to cast down to be able to call updateAnimation to animate the coin
  }
}

// Check when player dies
void checkDeath() {
  boolean collideEnemy = checkCollision(player, enemy); // player touches enemy
  boolean fallOffCliff = player.getBottom() > GROUND_LEVEL; // player falls
  if(collideEnemy || fallOffCliff) {
    player.lives--;
    if(player.lives==0) { // player has no more lives, game over
      isGameOver = true;
    } else { // player still has lives, reset game
      player.center_x = 100;
      player.setBottom(GROUND_LEVEL);
    }
  }
}

// Check when player collects coins
void collectCoins() {
  ArrayList<Sprite> coin_list = checkCollisionList(player, coins);
  if(coin_list.size() > 0) {
    for(Sprite coin: coin_list) {
      numCoins++;
      coins.remove(coin);
    }
  }
  
  // collect all coins to win
  if(coins.size() == 0) {
    isGameOver = true;
  }
}
  
void scroll() {
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if(player.getRight() > right_boundary) {
    view_x += player.getRight() - right_boundary;
  }
  
  float left_boundary = view_x + LEFT_MARGIN;
  if(player.getLeft() < left_boundary) {
    view_x -= left_boundary - player.getLeft();
  }
  
  float bottom_boundary = view_x + height - VERTICAL_MARGIN;
  if(player.getBottom() > bottom_boundary) {
    view_y += player.getBottom() - bottom_boundary;
  }
  
  float top_boundary = view_y + VERTICAL_MARGIN;
  if(player.getTop() < top_boundary) {
    view_y -= top_boundary - player.getTop();
  }
  
  translate(-view_x, -view_y);
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
        coins.add(c); // add to coins array
      }
      else if(values[col].equals("6")) { // create a spider
      
        // setting boundries for this enemy sprite
        // note: currently not ideal, boundries are to be 'hard coded' depending on the map design
        // i.e. with changing map design, the boundries have to possibly be adjusted
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        
        // initiate enemy object
        enemy = new Enemy(spider, 50/72.0, bLeft, bRight); // scaling down spider image with 72pixels width to 50pixels
        
        // setting enemy sprite position
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
      }
    }
   } 
}

// called when a key is pressed; initializes sprite movement
void keyPressed(){
  if(keyCode == RIGHT) {
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT) {
    player.change_x = -MOVE_SPEED;
  }
  else if(key == 'a' && isOnPlatform(player, platform)) {; 
    player.change_y = -JUMP_SPEED;
  }
  else if(isGameOver && key == ' ') {
    setup();
  }
}

// called when a key is released; stops sprite movement
void keyReleased(){
    if(keyCode == RIGHT) {
    player.change_x = 0;
  }
  else if(keyCode == LEFT) {
    player.change_x = 0;
  }
}
