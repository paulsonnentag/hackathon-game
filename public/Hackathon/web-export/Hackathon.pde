int millisAlt;
int untenBlocksBauen=5;
boolean untenRobust=false;
int manHeight=40;


int platformHeight=20;
int anzahlDerSpieler=3;

ArrayList<Platform> platforms;
ArrayList<Man> spielFiguren;

ArrayList<ArrayList> levelData;
int anzahlDerLevelDurchlauefe=0;

int newPlatformPosition;
int anzahlDerVerschiebung=5;



void setup() {
  frameRate(50);
  size(1024, 400);
  platforms= new ArrayList<Platform>();
  lastPlatformRobusticas=new ArrayList<bool>();
  levelData=new ArrayList<ArrayList>();
  spielFiguren=new ArrayList<Man>();

  String stringLevelData[] = loadStrings("level.txt");
  platformHeight=(int)(height/stringLevelData.length);



  for (int i=0; i<stringLevelData.length; i++) {
    ArrayList<Platform> platforms;
    platforms = new ArrayList<Platform>();
    for (int q=0; q<stringLevelData[i].length(); q++) {
      Platform platform= new Platform();
      platform.y=platformHeight*i;
      platform.x=platformHeight*q;

      if (stringLevelData[i].substring(q, q+1).equals("x")) {
        platform.platformRobust=true;
      }
      platforms.add(platform);
    }
    levelData.add(platforms);
  }



  //-2 ist die magische Zahl (vermutlich der Rand des Rechtecks)
  newPlatformPosition=stringLevelData[0].length()*platformHeight;
  println(newPlatformPosition);


  for (int i=0; i<anzahlDerSpieler; i++) {
    Man man = new Man();
    man.x=(100+(manHeight+4)*i);
    man.y=platformHeight+50;
    spielFiguren.add(man);
  }
}

void draw() {
  background(255);

  for (ArrayList platforms : levelData) {
    for (Platform platform : platforms) {
      platform.drawPlatform();

      platform.x-=2;

      if (platform.x < -platformHeight) {
        platform.x=newPlatformPosition;
      }
    }
    // anzahlDerLevelDurchlauefe
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


