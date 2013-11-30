class Man {

  String id;
  int x;
  int y;
  boolean manLebendig=true;
  boolean aufgekommen=false;
  int schwerkraft=1;


  void drawMan() {
    if (manLebendig==true) {
      rect(x, y, manWidth, manHeight);
    }
  }

  void turnGravity() {
    if (manLebendig && aufgekommen) {
      schwerkraft=-1*schwerkraft;
      aufgekommen=false;
    }
  }

  void simulateGravity() {

    if (y>height || y<0 || x<0) {
      manLebendig=false;
    }

    if (!aufgekommen) {
      y+=schwerkraft*5;
    }


    boolean platformUpdated=false;

    for (ArrayList platforms : levelData) {
      for (Platform platform : platforms) {
        if (platform.platformRobust) {
        if((y+manHeight)>platform.y && y<(platform.y+platformHeight)){
            if (abs((platform.x-(x+manWidth)))<2) { //theoretisch abs nicht nötig
              ellipse(platform.x,platform.y,10,10);
              x=x-2;
            }
            
          }

          if (schwerkraft<0) {
            if (platform.x+5 <= (x+manWidth) && x < (platform.x+platformHeight)) { // 5= Toleranzwert: nicht entfernen
              if (abs(platform.y+platformHeight-y)<3) {

                platformUpdated=true;
                aufgekommen=true;
              }
            }
          }
          if (schwerkraft>0) {
            if (platform.x+5 <= (x+manWidth) && x < (platform.x+platformHeight)) {
              if (abs(platform.y-(y+manHeight))<3) {

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
