// Coin is extending from AnimatedSprite, hence inheriting from the AnimatedSprite class, which inherits from the Sprite class
public class Coin extends AnimatedSprite {
  
  // Constructor - takes an image and scale
  public Coin(PImage img, float scale) {    
    
    // get image and scale from AnimnatedSprite class -> Sprite class
    super(img, scale);
    
    // set array with sprite images for coin animation
    standNeutral = new PImage[4];
    standNeutral[0] = loadImage("gold1.png");
    standNeutral[1] = loadImage("gold2.png");
    standNeutral[2] = loadImage("gold3.png");
    standNeutral[3] = loadImage("gold4.png");
    
    // make currentImages point to the created array
    currentImages = standNeutral; 
    
    // note: no moveleft or moveright array (as part of Sprite class) applicable for coin
  }
}
