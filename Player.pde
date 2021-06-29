// Class for creating an animated Player sprite
// Extending from AnimatedSprite to inherit
public class Player extends AnimatedSprite {
  
  // initialize Player specific variables
  int lives;// to keep track of the number of player lives 
  boolean onPlatform; // to keep track of if the player stands on a platform, which will influence the required animation
  boolean inPlace; // to keep track if player moves or stands still
  
  // adding additional arrays on top of the AnimatedSprite arrays, specific for Player behavior animations
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;  
  
  // Constructor - takes an image, scale
  public Player(PImage img, float scale) {
    super(img, scale);
    lives = 3; // set player initial number of lives
    direction = RIGHT_FACING; // set player initial moving direction sprite
    onPlatform = true;
    inPlace = true;
    
    // set sprites for standing left
    standLeft = new PImage[1];
    standLeft[0] = loadImage("player_stand_left.png");
   
   // set sprites for standing right
    standRight = new PImage[1];
    standRight[0] = loadImage("player_stand_right.png");
    
    // set sprites for jump left
    jumpLeft = new PImage[1];
    jumpLeft[0] = loadImage("player_jump_left.png");
   
   // set sprites for jump right
    jumpRight = new PImage[1];
    jumpRight[0] = loadImage("player_jump_right.png");
    
    // set sprites for moving left animation
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("player_walk_left1.png");
    moveLeft[1] = loadImage("player_walk_left2.png");
    
    // set sprites for moving right animation
    moveRight = new PImage[2];
    moveRight[0] = loadImage("player_walk_right1.png");
    moveRight[0] = loadImage("player_walk_right2.png");  
    
    // show player initial position in standRight position    
    // currentImages = standRight;
  }
   
  // overriding updateAnimation method to make the animation depending on the state of player
  @Override
  public void updateAnimation() {
    // check for state of Player object: is a player on a platform or not and is he in place or not? 
    onPlatform = isOnPlatform(this, platform); // check if player (this) collides with platform (global variable)
    inPlace = change_x == 00 && change_y == 0;
    super.updateAnimation(); // call updateAnimation of extended AnimatedSprite class
  }
 
  // overriding selectDirection method
  @Override
  public void selectDirection() {    
    if(change_x > 0) { // if going right
      direction = RIGHT_FACING; // set direction facing right
    } 
    else if (change_x < 0) { // if going left
      direction = LEFT_FACING; // set direction facing left    
    }
  }
  
     
  // overriding selectCurrentImages method
  // check Player facing direction, and based on that decide which animation sprites to use
  @Override
  public void selectCurrentImages() {
    
  if (direction == RIGHT_FACING) {
    if(inPlace) { // meaning player is standing
      currentImages = standRight;
    } 
    else if(!onPlatform) { // meaning player is jumping
      currentImages = jumpRight;
    }
    else {
      currentImages = moveRight;
    }
  }
  
  if (direction == LEFT_FACING) {
    if(inPlace) { // meaning player is standing
      currentImages = standLeft;
    } 
    else if(!onPlatform) { // meaning player is jumping
      currentImages = jumpLeft;
    }
    else {
      currentImages = moveLeft;
    }
  }
 }
}
