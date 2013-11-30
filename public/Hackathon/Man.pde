class Man {

  String id;
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


    boolean platformUpdated=false;

    for (ArrayList platforms : levelData) {
      for (Platform platform : platforms) {

        if (schwerkraft<0) {
          
        }
        if (schwerkraft>0) {
        }
      }
    }



    if (!platformUpdated) {
      aufgekommen=false;
    }
  }
}

