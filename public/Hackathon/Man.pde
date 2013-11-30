class Man {

  int x;
  int y;
  boolean manLebendig=true;
  boolean aufgekommen=false;
  int schwerkraft=1;


  void drawMan() {
    if (manLebendig==true) {
      ellipse(x, y, manHeight, manHeight);
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

          if (y>platform.y && y<platform.y+platformHeight) {
            if (platform.x-platformHeight/2-x<3) {
              if (x>platform.x+platformHeight) {
                x-=2;
              }
            }
          }


          if (schwerkraft<0) {
            if (platform.x-platformHeight <= x && x < platform.x+platformHeight) {
              if (abs(platform.y+(manHeight/2)+platformHeight-y)<3) {

                platformUpdated=true;
                aufgekommen=true;
              }
            }
          }
          if (schwerkraft>0) {
            if (platform.x-platformHeight <= x && x < platform.x+platformHeight) {
              if (abs(platform.y-(y+manHeight/2))<3) {

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

