// Coin is extending from AnimatedSprite, hence inheriting from the AnimatedSprite class, which inherits from the Sprite class
public class Coin extends AnimatedSprite {
  public Coin(PImage img, float scale) {
    super(img, scale);
    standNeutral = new PImage[4]; // array of 4 images
    standNeutral[0] = loadImage("gold1.png");
    standNeutral[1] = loadImage("gold2.png");
    standNeutral[2] = loadImage("gold3.png");
    standNeutral[3] = loadImage("gold4.png");
    currentImages = standNeutral; // point to it
    // note: no moveleft or moveright array (as part of Sprite class) applicable for coin
  }
}
