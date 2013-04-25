public class AreaColor extends
PixelColor {
  int myWidth;
  int myHeight;

  AreaColor(int inColor, int inX, int inY, int inWidth, int inHeight) {
    super(inColor, inX, inY, true);
    areaInit(inWidth, inHeight);
  }  
  AreaColor(int inRed, int inGreen, int inBlue, int inX, int inY, int inWidth, int inHeight) {
    super( color(inRed, inGreen, inBlue), inX, inY, true);
    areaInit(inWidth, inHeight);
  }
  AreaColor(int inX, int inY, int inWidth, int inHeight) {
    super(color(0), inX, inY, true);
    areaInit(inWidth, inHeight);
  }
  void areaInit(int inWidth, int inHeight) {
    myWidth = inWidth;
    myHeight = inHeight;
  }
}

