// Class for creating an enemy sprite
// Extending from AnimatedSprite to inherit
public class Enemy extends AnimatedSprite {
  
  // variables to set boundries between which the enemy will move back and forth
  float boundaryLeft, boundaryRight; 
  
  // Constructor - takes an image, scale and boundries
  public Enemy(PImage img, float scale, float bLeft, float bRight) {
    super(img, scale);
    
    // set sprites for moving left animation
    moveLeft = new PImage[3];
    moveLeft[0] = loadImage("spider_walk_left1.png");
    moveLeft[1] = loadImage("spider_walk_left2.png");
    moveLeft[2] = loadImage("spider_walk_left3.png");
    
    // set sprites for moving right animation
    moveRight = new PImage[3];
    moveRight[0] = loadImage("spider_walk_right1.png");
    moveRight[1] = loadImage("spider_walk_right2.png"); 
    moveRight[2] = loadImage("spider_walk_right3.png"); 
    
    // make currentImages point to the created (right facing) array    
    currentImages = moveRight;
    
    // set movement direction and boundries
    direction = RIGHT_FACING; 
    boundaryLeft = bLeft;
    boundaryRight = bRight;
    
    // give the enemy sprite a positive velocity
    change_x = 2; 
  }
  
  // overriding update method to make enemy sprite move
  void update() {
    
    // call update of Sprite(super)
    super.update();
    
    // if left side of spider <= left boundary, then fix by setting left side of spider to equal left boundary & change x velocity (= direction)
    if(getLeft() <= boundaryLeft) {
      setLeft(boundaryLeft);
      change_x *= -1;
    } 
    else if(getRight() >= boundaryRight) { // if right side of spider >= right boundary, then fix by setting right side of spider to equal right boundary & change x velocity (= direction)
      setRight(boundaryRight);
      change_x *= -1;
    }   
  }
}
