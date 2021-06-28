public class Sprite {

  // Declaring variables
  // Note: by convention in processing, encapsulation is ignored here to keep things simple
  PImage image;
  float center_x, center_y; // note: float is default type for processing
  float change_x, change_y; 
  float w, h; // for setting height and width of sprite (modifiable by a scale factor)
  
  // Constructor to initialize variables
  public Sprite(String filename, float scale, float x, float y) {
    image = loadImage(filename); // use filname to load image
    w = image.width * scale; // initialize height and width of sprite
    h = image.height * scale;
    center_x = x;
    center_y = y;
    change_x = 0;
    change_y = 0;
  }
  
   public Sprite(String filename, float scale) {
    this(filename, scale, 0, 0);
  }
  
  // Another Sprite constructor, that can be used to load an image just once, which is usefull for creating the platform
  public Sprite(PImage img, float scale) {
    image = img;
    w = image.width * scale;
    h = image.height * scale;
    center_x = 0;
    center_y = 0;
    change_x = 0;
    change_y = 0;
  }
  
  // display image
  public void display() {
    image(image, center_x, center_y, w, h); // draw image
  }
  
  // update position of image
  public void update() {
    center_x += change_x;
    center_y += change_y;
  }  
}
