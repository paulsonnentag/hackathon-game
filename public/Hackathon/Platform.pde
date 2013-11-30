class Platform {
  int x;
  int y;
  boolean platformRobust;

  void drawPlatform() {
    if (platformRobust) {
      rect(x, y, platformHeight, platformHeight);
      
    }
  }
}

