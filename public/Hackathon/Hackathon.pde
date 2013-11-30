int millisAlt;
int untenBlocksBauen=5;
boolean untenRobust=false;
boolean isRunning=false;
int manHeight=186/3;
int manWidth=121/3;




int platformHeight=30;

ArrayList<Platform> platforms;
ArrayList<Man> spielFiguren;

ArrayList<ArrayList> levelData;
ArrayList<String[]> stringLevelData;

int newPlatformPosition;

int currentLevelNo=0;


void setup() {
  frameRate(50);
  size(1024, 400);
  platforms= new ArrayList<Platform>();
  lastPlatformRobusticas=new ArrayList<bool>();
  levelData=new ArrayList<ArrayList>();
  spielFiguren=new ArrayList<Man>();
  stringLevelData=new ArrayList<String[]>();

  for (int i=0; i<4; i++) {
    String[] stringOneLevelData=loadStrings("level"+i+".txt"); 
    stringLevelData.add(stringOneLevelData);
  }

  platformHeight=(int)(height/stringLevelData.get(0).length);


  for (int i=0; i<stringLevelData.get(currentLevelNo).length; i++) {
    ArrayList<Platform> platforms;
    platforms = new ArrayList<Platform>();
    for (int q=0; q<stringLevelData.get(currentLevelNo)[i].length(); q++) {
      Platform platform= new Platform();
      platform.y=platformHeight*i;

      platform.x=platformHeight*q;

      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("x")) {
        platform.platformRobust=true;
      }
      platforms.add(platform);
      platform.xPosInArray=q;
      platform.yPosInArray=i;
    }
    levelData.add(platforms);
  }



  //-2 ist die magische Zahl (vermutlich der Rand des Rechtecks)
  newPlatformPosition=(stringLevelData.get(currentLevelNo)[0].length()-1)*platformHeight-2;
  println(newPlatformPosition);


  addPlayer("la");
  //addPlayer("fr");

  startGame();

  //start game manually
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


          if (platform.yPosInArray==0 && platform.xPosInArray==0) {
            currentLevelNo=(int)random(0, 4);
            println(currentLevelNo);
          }

          if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("x")) {
            platform.platformRobust=true;
          } 
          else {
            platform.platformRobust=false;
          }
        }
      }
    }
  }

  for (Man man: spielFiguren) {

    if (isRunning) {
      man.simulateGravity();
    }

    if (man.manLebendig) {
      man.drawMan();
    } 
    else {
      removePlayer(man.id);

     if (spielFiguren.size() == 1) {
       isRunning = false;
       gameOver();
     }
    }
  }
}

void startGame () {
  isRunning = true;
}

void addPlayer (String id) {
  Man man = new Man();
  man.x=(100+(manWidth+4)*spielFiguren.size());
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

//manually flip gravity
void keyPressed() {
  if (key == '1') {
    touchDown("la");
  }

  if (key == '2') {
    touchDown("fr");
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

