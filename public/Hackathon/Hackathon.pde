int millisAlt;
int untenBlocksBauen=5;
boolean untenRobust=false;
boolean isRunning=false;
int manHeight=40;

int platformHeight=20;

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

}

void draw() {
  background(255);

  for (ArrayList platforms : levelData) {
    for (Platform platform : platforms) {
      platform.drawPlatform();

      if (isRunning) {
        platform.x-=2;
  
        if (platform.x < -platformHeight) {
          platform.x=newPlatformPosition;
        }
      }
      
    }
    // anzahlDerLevelDurchlauefe
  }

  for (Man man: spielFiguren) {
    
    if (isRunning) {
      man.simulateGravity();
    }
    
    man.drawMan();
  }
}

void startGame () {
  isRunning = true; 
}

void addPlayer (String id) {
  Man man = new Man();
  man.x=(100+(manHeight+4)*spielFiguren.size());
  man.y=platformHeight+50;
  man.id = id;
  spielFiguren.add(man);
}

void removePlayer (String id) {
  for (int i = 0; i < spielFiguren.size(); i++) {
    if (spielFiguren.get(i).id == id) {
      spielFiguren.remove(i);
    }
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


void touchDown(String id) {
  for (Man man: spielFiguren) {
    if (man.id == id) {
      man.turnGravity();
    }
  }
}

