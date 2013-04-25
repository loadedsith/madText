//import controlP5.*;
import java.awt.Point;

PImage img;
PImage img2x;
PImage img2xAlpha;
int direction = 1;
float signal;
float imageScale=2;
PFont font;
int rate = 0;
boolean backgroundDrawn = true;

boolean debugRectangle = true;
int fontSize = 13;
int wordPadding = fontSize/3;
color bgColor = color(255, 255, 255);

int destinationRectangleAverage = 0;
int theStringIndex=0;
String theString="";

int[] fontSizes = { 
  11, 12, 18
};
PFont[] fonts = new PFont[fontSizes.length];
/*String[] stringArray = {
  "This", "is", "our", "world", "now...", "the", "world", "of", "the", "electron", "and", "the", "switch,", "the", "beauty", "of", "the", "baud.", "We", "make", "use", "of", "a", "service", "already", "existing", "without", "paying", "for", "what", "could", "be", "dirt-cheap", "if", "it", "wasn't", "run", "by", "profiteering", "gluttons,", "and", "you", "call", "us", "criminals.", "We", "explore...", "and", "you", "call", "us", "criminals.", "We", "seek", "after", "knowledge...", "and", "you", "call", "us", "criminals.", "We", "exist", "without", "skin", "color,", "without", "nationality,", "without", "religious", "bias...", "and", "you", "call", "us", "criminals.", "You", "build", "atomic", "bombs,", "you", "wage", "wars,", "you", "murder,", "cheat,", "and", "lie", "to", "us", "and", "try", "to", "make", "us", "believe", "it's", "for", "our", "own", "good,", "yet", "we're", "the", "criminals.", "Yes,", "I", "am", "a", "criminal.", "My", "crime", "is", "that", "of", "curiosity.", "My", "crime", "is", "that", "of", "judging", "people", "by", "what", "they", "say", "and", "think,", "not", "what", "they", "look", "like.", "My", "crime", "is", "that", "of", "outsmarting", "you,", "something", "that", "you", "will", "never", "forgive", "me", "for.", "I", "am", "a", "hacker,", "and", "this", "is", "my", "manifesto.", "You", "may", "stop", "this", "individual,", "but", "you", "can't", "stop", "us", "all...", "after", "all,", "we're", "all", "alike."
};
String[] stringArray = {
 "Who", "knows", "why", "people", "in", "history", "did", "good", "things?", 
 "For", "all", "we", "know", "Jesus", "was", "trying", "to", "get", 
 "the", "loaves", "and", "fishes", "account."
 };*/
// String[] stringArray = "I keep looking for a place to fit. Where I can speak my mind. I've been trying hard to find the people. That I won't leave behind. They say I got brains. But they ain't doing me no good. I wish they could. Each time things start to happen again. I think I got something good goin' for myself. But what goes wrong. Sometimes I feel very sad, (Can't find nothin' I can put my heart and soul into) I guess I just wasn't made for these times, Every time I get the inspiration, To go change things around, No one wants to help me look for places, Where new things might be found, Where can I turn when my fair weather friends cop out. What's it all about, Each time things start to happen again, I think I got something good goin' for myself, But what goes wrong, Sometimes I feel very sad, (Can't find nothin' I can put my heart and soul into) I guess I just wasn't made for these times.".split(" ");
//String[] stringArray = "It's young and it's beautiful and no one else is going to figure out how to say that about beans.".split(" ");
String[] stringArray = "Your father's nice. He's not my real father. People don't understand. Are you adopted? Actually, I'm from Mars. It's fine if you don't believe me, but that's where I'm from. I'm a full-blooded martian. Don't worry. There's no plot to take over Earth. We're just displaced. I can tell you don't believe me. That's okay. We're a big secret. They even tried to hide it from me. That man, my father, told me a story I was born in a concentration camp, but you know that's impossible. And I never met my mother because she supposedly died there. That's convenient. Next thing I know, Morris there finds me in a Swedish orphanage.I was five. I remember it. And then I got this one communication. A simple order. Stay where you are. Are there others like you? I don't know. I haven't been able to find any.".split(" ");
String imageName = "ginsberg.png";
int stringArrayLength = stringArray.length;
int stringArrayCount = 0;
int oneThreshholdMin =0;
int oneThreshholdMax = 55;

int redThreshholdMin = oneThreshholdMin;
int redThreshholdMax = oneThreshholdMax;  
int greenThreshholdMin = oneThreshholdMin;
int greenThreshholdMax = oneThreshholdMax; 
int blueThreshholdMin = oneThreshholdMin;
int blueThreshholdMax = oneThreshholdMax;

int lastCheckedX = 0;
int lastCheckedY = 0; 
void setup() {
  noSmooth();
  background(bgColor);
  img = loadImage(imageName);
  img2x = loadImage(imageName);
  img2x.resize((int)(img.width*imageScale), (int)(img.height*imageScale));
  img2xAlpha = loadImage(imageName);
  img2xAlpha.resize((int)(img.width*imageScale), (int)(img.height*imageScale));

  noFill();
  noStroke();
  frameRate(30);
  size((int)(img.width*imageScale), (int)(img.height*imageScale));
  //textFont(createFont("Georgia", fontSize));

  for (int i = 0; i < fontSizes.length; i++) {
    println("making a bunch of fonts!");
    fonts[i] = createFont("Georgia", fontSizes[i]);
  }
  // noLoop();
}
PixelColor getNextEmptySpotForThis(int fontSize, String theString, int inRedThreshholdMin, int inRedThreshholdMax, 
int inGreenThreshholdMin, int inGreenThreshholdMax, 
int inBlueThreshholdMin, int inBlueThreshholdMax) {
  int sourceTextWidth = (int)(3+(textWidth(theString)+fontSize/3)/imageScale);
  int sourceTextHeight = (int)(3+ (fontSize+fontSize/3)/imageScale);

  int startX = lastCheckedX;
  int startY=lastCheckedY;
  int maxAttempts = 800;
  for (int attempts = maxAttempts; attempts>=0; attempts--) {
    boolean success = false;
    img.loadPixels();
    for ( int checkY = lastCheckedY; checkY<=(int)img.height;checkY+=sourceTextHeight) {

      for ( int checkX = lastCheckedX; checkX<=(int)img.width; checkX+=sourceTextWidth) {


        lastCheckedX +=sourceTextWidth;
        if (lastCheckedX>img.width) { 
          lastCheckedY +=sourceTextHeight;
          //println("!!!!!---++>>"+sourceTextHeight);
          lastCheckedX=0;
        }
        int averageColor = averageColorsOfThisArea(img, checkX, checkY, sourceTextWidth, sourceTextHeight);
        int sampleRed = (int)red(averageColor);
        int sampleGreen = (int)green(averageColor);
        int sampleBlue = (int)blue(averageColor);


        //lastCheckedY = checkY;
        if (sampleRed >= inRedThreshholdMin && sampleRed <= inRedThreshholdMax) {      
          // println("red good");
          if (sampleGreen >= inGreenThreshholdMin && sampleGreen <= inGreenThreshholdMax ) {
            //  println("green good");
            if (sampleBlue >= inBlueThreshholdMin && sampleBlue <= inBlueThreshholdMax ) {
              println("Got a threshold from the source image! X,Y: "+checkX+","+checkY);
              //here
              //fill(99);
              //rect(checkX, checkY, sourceTextWidth, sourceTextHeight);

              //debugRectangle(checkX, checkY, sourceTextWidth, sourceTextHeight);
              success = true;

              return new PixelColor(color(sampleRed, sampleGreen, sampleBlue), checkX, checkY, success );
            }
          }
        }
      }
    }

    if (success == true)
    {

      println("attempts success check is working");
      //   break;
    }
    else {
      println("attempts:try again");
    }
  }
  return new PixelColor(0, 0, 0, false);
}
PixelColor getNextAreaFromImgWithRGBThreshhold(int fontSize, String theString, int inRedThreshholdMin, int inRedThreshholdMax, 
int inGreenThreshholdMin, int inGreenThreshholdMax, 
int inBlueThreshholdMin, int inBlueThreshholdMax) {
  int sourceTextWidth = (int)((theString.length()*fontSize)/imageScale);
  int sourceTextHeight = (int)( fontSize/imageScale);
  if (lastCheckedX+sourceTextWidth>img.width) {
    lastCheckedY+=(sourceTextHeight);
    lastCheckedX = 0;
  }
  int startX =lastCheckedX;
  int startY = lastCheckedY;
  boolean success = false;
  for (int thresholdLoopCounter = 0; thresholdLoopCounter <100; thresholdLoopCounter++) {
    success = false;
    PixelColor thePixelColor = getNextEmptySpotForThis(fontSize, theString, inRedThreshholdMin, inRedThreshholdMax, inGreenThreshholdMin, inGreenThreshholdMax, inBlueThreshholdMin, inBlueThreshholdMax);
    int sampleX;
    int sampleY;


    sampleX = thePixelColor.myX;
    sampleY = thePixelColor.myY;

    int sampleRed = (int)red(img.get(sampleX, sampleY));
    int sampleGreen = (int)green(img.get(sampleX, sampleY));
    int sampleBlue = (int)blue(img.get(sampleX, sampleY));
    fill(sampleRed, sampleGreen, sampleBlue);
    println("r:"+sampleRed+ " g:"+sampleGreen+ " b:"+sampleBlue);
    if (sampleRed >= inRedThreshholdMin && sampleRed <= inRedThreshholdMax) {      
      // println("red good");
      if (sampleGreen >= inGreenThreshholdMin && sampleGreen <= inGreenThreshholdMax ) {
        //  println("green good");
        if (sampleBlue >= inBlueThreshholdMin && sampleBlue <= inBlueThreshholdMax ) {
          println("Got a threshold from the source image!");
          success = true;
          return new PixelColor(color(sampleRed, sampleGreen, sampleBlue), sampleX, sampleY, success );
        }
      }
    }
  }
  println("getAPixelFromImgWithRGBThreshhold: Failed");
  return new PixelColor(false);
}
PixelColor getAPixelFromImgWithRGBThreshhold(int inRedThreshholdMin, int inRedThreshholdMax, 
int inGreenThreshholdMin, int inGreenThreshholdMax, 
int inBlueThreshholdMin, int inBlueThreshholdMax) {

  boolean success = false;
  for (int thresholdLoopCounter = 0; thresholdLoopCounter <100; thresholdLoopCounter++) {
    success = false;

    int sampleX = (int)random(img.width); 
    int sampleY = (int)random(img.height);
    int sampleRed = (int)red(img.get(sampleX, sampleY));
    int sampleGreen = (int)green(img.get(sampleX, sampleY));
    int sampleBlue = (int)blue(img.get(sampleX, sampleY));
    fill(sampleRed, sampleGreen, sampleBlue);
    println("r:"+sampleRed+ " g:"+sampleGreen+ " b:"+sampleBlue);
    if (sampleRed >= inRedThreshholdMin && sampleRed <= inRedThreshholdMax) {      
      // println("red good");
      if (sampleGreen >= inGreenThreshholdMin && sampleGreen <= inGreenThreshholdMax ) {
        //  println("green good");
        if (sampleBlue >= inBlueThreshholdMin && sampleBlue <= inBlueThreshholdMax ) {
          println("Got a threshold from the source image!");
          success = true;
          return new PixelColor(color(sampleRed, sampleGreen, sampleBlue), sampleX, sampleY, success );
        }
      }
    }
  }
  println("getAPixelFromImgWithRGBThreshhold: Failed");
  return new PixelColor(false);
}
int averageColorsOfThisArea(PImage theImage, int startX, int startY, int wide, int high) {
  theImage.loadPixels();
  int theRed = 0;
  int theGreen = 0;
  int theBlue = 0;
  int firstPixel = startX+(startY*img.width);

  if (firstPixel < theImage.pixels.length-1 && firstPixel>0) {
    theRed = (int )red(theImage.pixels[firstPixel]);
    theBlue = (int )blue(theImage.pixels[firstPixel]);
    theGreen = (int )green(theImage.pixels[firstPixel]);
  }
  int pixelCount = 0;

  for ( int checkX = startX; checkX<=(int)startX+wide; checkX++) {

    for ( int checkY = startY; checkY<=(int)startY+high;checkY++) {

      //println("Goober!");
      int thisPixel = checkX+(checkY*theImage.width);

      try {
        //println("the pixel, raw: "+pixels[thisPixel]);
        theRed += red(theImage.pixels[thisPixel]);
        theGreen += green(theImage.pixels[thisPixel]);
        theBlue += blue(theImage.pixels[thisPixel]);
        //theImage.pixels[thisPixel]=color(0,0,255);
        //color randColor = color(random(255),random(255),random(255));
        //fill(randColor);
        //rect(checkX, checkY, 2,2);
        pixelCount++;
      }
      catch(Exception e) {
        println(e);
      }
    }
  }

  int averageRed = theRed/(pixelCount+1);
  int averageGreen = theGreen/(pixelCount+1);
  int averageBlue = theBlue/(pixelCount+1);
  //println("averageRed"+averageRed);
  //updatePixels();

  return color(averageRed, averageGreen, averageBlue);
}

int averageColorsOfThisArea(int startX, int startY, int wide, int high) {
  loadPixels();
  int theRed = 0;
  int theGreen = 0;
  int theBlue = 0;
  int firstPixel = startX+(startY*img.width);

  if (firstPixel < pixels.length-1 && firstPixel>0) {
    theRed = (int )red(pixels[firstPixel]);
    theBlue = (int )blue(pixels[firstPixel]);
    theGreen = (int )green(pixels[firstPixel]);
  }
  int pixelCount = 0;

  for ( int checkX = startX; checkX<=(int)startX+wide; checkX++) {

    for ( int checkY = startY; checkY<=(int)startY+high;checkY++) {

      //println("Goober!");
      int thisPixel = checkX+(checkY*width);

      try {
        //println("the pixel, raw: "+pixels[thisPixel]);
        theRed += red(pixels[thisPixel]);
        theGreen += green(pixels[thisPixel]);
        theBlue += blue(pixels[thisPixel]);
        // pixels[thisPixel]=color(0,0,255);
        pixelCount++;
      }
      catch(Exception e) {
        println(e);
      }
    }
  }

  int averageRed = theRed/(pixelCount+1);
  int averageGreen = theGreen/(pixelCount+1);
  int averageBlue = theBlue/(pixelCount+1);
  println("averageRed"+averageRed);
  //updatePixels();

  return color(averageRed, averageGreen, averageBlue);
}

int averageTextArea(int sampleX, int sampleY) {
  int startX =(int)(sampleX*imageScale-(fontSize/3));
  int startY =(int)(sampleY*imageScale-fontSize-(fontSize/3/2));

  int wide = (int) (textWidth(theString)+(fontSize/3/2));
  int high = (int) (fontSize/3+(fontSize));
  int destinationRectangleAverage = averageColorsOfThisArea( startX, startY, wide, high);
  println("red(destinationRectangleAverage)"+red(destinationRectangleAverage));
  return destinationRectangleAverage;
}
PixelColor findEmptyAreaForThisText(int tries, String theString, int fontSize, int wordPadding) {

  //todo: aveage the whole area to find a empty area, rather than just a point
  PixelColor results = new PixelColor(false);
  for (int i = 0; i<tries;i++) {
    results = getNextAreaFromImgWithRGBThreshhold(fontSize, theString, redThreshholdMin, redThreshholdMax, greenThreshholdMin, greenThreshholdMax, blueThreshholdMin, blueThreshholdMax);
    if (!results.successfullyPicked == true) {

      println("results.successfullyPicked = false");
      break;
    }
    fill(0, 255, 0);
    //rect(results.myX, results.myY,2,2);
    println("Found an Empty Pixel");

    println("Begin Looking for empty Area");


    int average = averageTextArea(results.myX, results.myY);
    println("red(average)"+red(average));
    PixelColor results2 = new PixelColor(false);
    results2.myRed = (int) red(average);
    results2.myGreen = (int) green(average);
    results2.myBlue = (int) blue(average);

    //todo: change this to compare source image to current pixels!
    //average source image pixels using image scale
    if (results2.myRed >=red(bgColor)) {
      println("theRed >= " + 0 + " && theRed <= " + redThreshholdMax);
      if (results2.myGreen >=green(bgColor) ) {
        //println("green good");
        if (results2.myBlue >=blue(bgColor) ) {

          println("Success2:2, destination average found: "+results.myRed);
          results.successfullyPicked = true;
          return results;
        }
      }
    }    
    println("Second Level threshold failed!");
  }
  return new PixelColor(false);
}


void debugRectangle( int startX, int startY, int wide, int high) {
  if (debugRectangle)
  {
    color randColor = color((int)random(255), (int)random(255), (int)random(255));
    stroke(randColor);
    noFill();
    rect(startX, startY, wide, high);
  }
}
boolean generateText() {

  // int myIndex;
  theStringIndex=0;
  theString="";
  int destinationRectangleAverage = 255;
  loadPixels();
  theStringIndex = (stringArrayCount)%stringArrayLength;
  theString = stringArray[theStringIndex];
  stringArrayCount++;

  for (int i = 0; i<= rate;i++) {
    int tries = 4000;

    int fontSizeIndex = (int)random(0, fonts.length-1);
    if (fontSizeIndex <= fonts.length-1)
    { 
      wordPadding = fontSize/4;
      textFont(fonts[fontSizeIndex]);
      fontSize = fontSizes[fontSizeIndex];
      wordPadding = fontSize/4;
      PixelColor result = findEmptyAreaForThisText(tries, theString, fontSize, wordPadding);
      if (result.successfullyPicked==true) {
        fill(result.myRed, result.myGreen, result.myBlue);
        println("draw shint!!!!!"+theString+", "+result.myX*imageScale+", "+result.myY*imageScale);
        //fill(result.myRed, result.myGreen, result.myBlue );
        //fill(0 );
        saveImage();
        text(theString, result.myX*imageScale, result.myY*imageScale);
        break;
      }
    } 
    else {
      println("font problems yo!");
    }

    //println("fonts.length:" +fonts.length);
  }
  //println("word"+theString+", count: "+stringArrayCount+", index:"+theStringIndex);
  return true;
}
public void saveImage() {
  String path = dataPath("Images/");

  File file = new File(path);
  int sizeOfFolder = 0;

  if (file.exists() && file.isDirectory()) {
    sizeOfFolder = file.listFiles().length;
  }
  try {
    saveFrame((dataPath("images/" + (sizeOfFolder+1)+ ".jpg")));
  }
  catch(Exception e) {
    println("Image failed to Save, probably just a corrupt one");
  }
}
void draw() {
  loadPixels();
  if (backgroundDrawn!=true) {
    set(0, 0, img2x);
    backgroundDrawn = true;
  }
  if (keyPressed) {
    // set(0, 0, img2x);  // fast way to draw an image
    //  point(sx, sy);
    //rect(sx - 5, sy - 5, 10, 10);
    //  backgroundDrawn=false;
  } 
  else {
    int maxAttempts = 20;
    boolean success = false;
    for (int attempts = 0; attempts<maxAttempts; attempts++) {
      if (generateText()==true) {
        success = true;
        break;
      }
    }
    //saveFrame();
    if (!success) {
      noLoop();
      println("Shows Over!");
    }
  }
}

