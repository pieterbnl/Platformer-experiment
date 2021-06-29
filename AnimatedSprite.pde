// This class is used for every animated sprite
// note: below could better be setup as abstract classes and extended from there 
public class AnimatedSprite extends Sprite {
  
  PImage[] currentImages; // array of images that will be cycled through to display an animation
  PImage[] standNeutral; // array of neutral/standing images
  PImage[] moveLeft; // array of images moving left 
  PImage[] moveRight; // array of images moving right
  
  int direction; // to be one of 3 values: NEUTRAL_FACING, RIGHT_FACING or LEFT_FACING
  int index; // used to keep track of index when looping through one of the images arrays 
  int frame; // used to keep track of frame rate of the animation; i.e. used to control the speed of the animation by setting a frame rate, preventing it from looking glitchy
  
  // constructor
  public AnimatedSprite(PImage img, float scale) {
    super(img, scale); // calling img and scale from Sprite class
    direction = NEUTRAL_FACING; // initialize default direction
    index = 0; // initalize default index
    frame = 3.402823466 E + 38; // initalize default frame rate
  }
  
  // create animation of images
  public void updateAnimation() {
    frame++;
    text("Frame:" + frame, view_x + 50, view_y + 150);
    if(frame % 5 == 0) { // update image every 5 frames
      selectDirection(); // select direction that image will be facing
      selectCurrentImages(); // select the relevant array with images, depending on the just determined facing direction
      advanceToNextImage(); // pick a particular index of the selected array
    }
    if (frame == 60)
      frame = 0;
  }
  
  // check which direction the player is facing
  public void selectDirection() {
    if(change_x > 0) { // if going right
      direction = RIGHT_FACING; // set direction facing right
    } 
    else if (change_x < 0) { // if going left
    direction = LEFT_FACING; // set direction facing left    
    }
    else {
      direction = NEUTRAL_FACING;
    }
  }
  
  // decide which array to pick, depending on which direction the player is facing
  public void selectCurrentImages() {
    if (direction == RIGHT_FACING) {
      currentImages = moveRight;
    }
    else if (direction == LEFT_FACING) {
      currentImages = moveLeft;
    }
    else {
      currentImages = standNeutral;
    }    
  }
  
  public void advanceToNextImage() {
    index++; // move to next image
    if(index == currentImages.length) { // prevent running out of bounds
      index = 0; // reset back to first image in the array
    }    
    image = currentImages[index]; // set image as per current index of the array
  }
  
}
