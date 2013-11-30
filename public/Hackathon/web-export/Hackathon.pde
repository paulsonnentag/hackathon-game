int millisAlt;
int untenBlocksBauen=5;
boolean untenRobust=false;
int manHeight=40;


int platformHeight=20;
int anzahlDerSpieler=3;

ArrayList<Platform> platforms;
ArrayList<bool> lastPlatformRobusticas; //provisorisch, Nutzen umstritten
ArrayList<Man> spielFiguren;


int newPlatformPosition;
int anzahlDerVerschiebung=5;

void setup() {
  frameRate(35);
  size(1024, 400);
  platforms= new ArrayList<Platform>();
  lastPlatformRobusticas=new ArrayList<bool>();
  spielFiguren=new ArrayList<Man>();

  for (int i=0; i<anzahlDerVerschiebung; i++) {

    lastPlatformRobusticas.add(true);
  }

  for (int i=0; i<((int)(width/platformHeight)+2); i++) {


    Platform platformOben=new Platform();
    platformOben.y=0;
    platformOben.x=platformHeight*i;
    platformOben.platformRobust=true;
    platforms.add(platformOben);


    Platform platformUnten=new Platform();
    platformUnten.y=height-platformHeight;
    platformUnten.x=platformHeight*i;
    platformUnten.platformRobust=true;
    platforms.add(platformUnten);
  }
  //-2 ist die magische Zahl (vermutlich der Rand des Rechtecks)
  newPlatformPosition=((int)(width/platformHeight)+1)*platformHeight-2;
  println(newPlatformPosition);


  for (int i=0; i<anzahlDerSpieler; i++) {
    Man man = new Man();
    man.x=(100+(manHeight+4)*i);
    man.y=50;
    spielFiguren.add(man);
  }
}

void draw() {
  background(255);

  for (Platform platform : platforms) {
    platform.drawPlatform();
    platform.x-=2;

    if (platform.x < -platformHeight) {
      platform.x=newPlatformPosition;
      if (platform.y==height-platformHeight) {
        if (untenBlocksBauen<-1) {
          untenBlocksBauen=(int)random(5, 10);
          untenRobust=!untenRobust;
        } 

        untenBlocksBauen--;
        platform.platformRobust=untenRobust;
        lastPlatformRobusticas.add(untenRobust);
      } 
      else {
        platform.platformRobust=lastPlatformRobusticas.get(0);
        lastPlatformRobusticas.remove(0);
      }
    }
  }
  for (Man man: spielFiguren) {
    man.simulateGravity();
    man.drawMan();
  }
}


void keyPressed() {
  if (key == '1') {
    touchDown(0);
  }

  if (key == '2') {
    touchDown(1);
  }

  if (key == '3') {
    touchDown(2);
  }
}


void touchDown(int ID) {
  spielFiguren.get(ID).turnGravity();
}

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


