class Platform {
  int x;
  int y;
  boolean platformRobust;


  void drawPlatform() {
    if (platformRobust) {
      if (y==0) {
        pushMatrix();
        translate(x+platformHeight,y+platformHeight);
        rotate(PI);
        image(bodenDecke, 0, 0, platformHeight, platformHeight);
        popMatrix();
      } 
      else {
        image(bodenDecke, x, y, platformHeight, platformHeight);
      }
    }
  }
}
