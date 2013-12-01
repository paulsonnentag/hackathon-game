class Platform {
  int x;
  int y;
  int xPosInArray;
  int yPosInArray;
  boolean platformRobust;
  int platformType;

  

  Platform() {
    //Konstruktor
  }

  void drawPlatform() {

    if (platformRobust) {

      image(bodenDecke[platformType], x, y, platformHeight, platformHeight);
    }
  }
}

