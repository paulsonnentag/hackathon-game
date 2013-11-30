class Man {

  int x;
  int y;
  boolean schwerKraftUnten;
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
      println("TURN");
    }
  }

  void simulateGravity() {
    if (y>height-platformHeight || y<platformHeight) {
      manLebendig=false;
    }

    if (!aufgekommen) {
      y+=schwerkraft*5;
    }

    if (y>(height-platformHeight*2) || y<platformHeight*2) {

      boolean platformUpdated=false;

      for (Platform platform : platforms) {
        if (y>height/2) {
          if (platform.y==height-platformHeight) {

            if (platform.x-4<(x+manHeight/2) && platform.x+4+platformHeight>(x+manHeight/2)) {
              if (platform.platformRobust) {
                aufgekommen=true;
                platformUpdated=true;
              }
            }
          }
        } 
        else {
          if (platform.y==0) {

            if (platform.x-4<(x+manHeight/2) && platform.x+4+platformHeight>(x+manHeight/2)) {
              if (platform.platformRobust) {
                aufgekommen=true;
                platformUpdated=true;
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
}

