public class PixelColor {
  color myColor;
  int myRed;
  int myGreen;
  int myBlue;
  int myX;
  int myY;
  boolean successfullyPicked;
  PixelColor(int inColor, int inX, int inY, boolean inSuccessfullyPicked) {
    init( inColor, inX, inY, inSuccessfullyPicked);
  }  
  PixelColor(int inRed, int inGreen, int inBlue, int inX, int inY, boolean inSuccessfullyPicked) {
    init( color(inRed, inGreen, inBlue), inX, inY, inSuccessfullyPicked);
  }  
  PixelColor(boolean inSuccesfullyPicked) {
    init(color(0),0,0,inSuccesfullyPicked);
  }
  void init(int inColor, int inX, int inY, boolean inSuccessfullyPicked) {
    myRed =(int) red(inColor);
    myGreen =(int) green(inColor);
    myBlue =(int) blue(inColor);
    myX = inX;
    myY = inY;
    successfullyPicked = inSuccessfullyPicked;

  }
}

