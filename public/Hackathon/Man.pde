class Man {

  String id;
  //typ can be "kerl-0" or "laufen0"
  String type="kerl-0";
  int x;
  int y;
  boolean manLebendig=true;
  boolean aufgekommen=false;
  int schwerkraft=1;
  int lastFrameChangeMillis=0;
  int nextFrameChange=100;
  int currentImage=(int)random(1, 3);
  boolean gerade;
  int maximumRun=0;


  PImage[] charBild;

  Man() {
    //nicht hier laden, sonst wird das bild für jedes Objekt geladen!!!
    charBild=new PImage[4];
    
    for (int i=0; i<charBild.length; i++) {
      
      charBild[i]=loadImage(type+i+".png");
      
    }
  }

  void drawMan() {
    if (millis()-lastFrameChangeMillis>nextFrameChange && isRunning) {
      currentImage++;
      lastFrameChangeMillis=millis();
    }
    if (currentImage>charBild.length-1) currentImage=1;

    if (manLebendig==true) {
      //rect(x, y, manWidth, manHeight);
      if (schwerkraft<0) {
        pushMatrix();
        translate(x, y+manHeight);
        rotate(PI);
        scale(-1.0, 1.0);
        if(isRunning) image(charBild[currentImage], 0, 0, manWidth, manHeight);
        else image(charBild[0], 0, 0, manWidth, manHeight);
        popMatrix();
      }
      if (schwerkraft>0) {
        if(isRunning) image(charBild[currentImage], x, y, manWidth, manHeight);
        else image(charBild[0], x, y, manWidth, manHeight);
      }
    }
  }

  void turnGravity() {
    if (manLebendig && aufgekommen) {
      schwerkraft=-1*schwerkraft;
      aufgekommen=false;
    }
  }

  void simulateGravity() {

    //wenn der Spieler zu weit hinten -> beschleunigen
    if (x<(width/2-(maximumRun)) && isRunning) {
      x++;
    }

    if (y>height || y<0 || x<-manWidth) {
      manLebendig=false;
    }

    if (!aufgekommen) {
      y+=schwerkraft*5;
    }


    boolean platformUpdated=false;

    for (ArrayList platforms : levelData) {
      for (Platform platform : platforms) {
        if (platform.platformRobust) {
          if ((y+manHeight)>platform.y && y<(platform.y+platformHeight)) {
            if (abs((platform.x-(x+manWidth)))<2) { //theoretisch abs nicht nötig
              // x=(platform.x-1); 
              x= platform.x-manWidth-2;
              //x=x-2;
            }
          }

          if (schwerkraft<0) {
            if (platform.x+5 <= (x+manWidth) && x < (platform.x+platformHeight)) { // 5= Toleranzwert: nicht entfernen
              if (abs(platform.y+platformHeight-y)<3) {
                y=platform.y+platformHeight;
                platformUpdated=true;
                aufgekommen=true;
              }
            }
          }
          if (schwerkraft>0) {
            if (platform.x+5 <= (x+manWidth) && x < (platform.x+platformHeight)) {
              if (abs(platform.y-(y+manHeight))<3) {
                y = (platform.y-manHeight);
                platformUpdated=true;
                aufgekommen=true;
              }
            }
          }
        }
      }
    }


    if (!platformUpdated) {
      aufgekommen=false;
    }
  }
}

