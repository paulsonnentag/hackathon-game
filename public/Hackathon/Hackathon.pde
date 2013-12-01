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
int levelCount=4;

PImage[] bodenDecke;

void setup() {
  frameRate(50);
  size(1024, 600);
  platforms= new ArrayList<Platform>();
  lastPlatformRobusticas=new ArrayList<bool>();
  levelData=new ArrayList<ArrayList>();
  spielFiguren=new ArrayList<Man>();
  stringLevelData=new ArrayList<String[]>();

  for (int i=0; i<levelCount+1; i++) {
    String[] stringOneLevelData=loadStrings("level"+i+".txt"); 
    stringLevelData.add(stringOneLevelData);
  }

  bodenDecke=new PImage[6];
  bodenDecke[0]=loadImage("L.png");
  bodenDecke[1]=loadImage("T.png");
  bodenDecke[2]=loadImage("N.png");
  bodenDecke[3]=loadImage("H.png");
  bodenDecke[4]=loadImage("U.png");
  bodenDecke[5]=loadImage("C.png");



  platformHeight=(int)(height/stringLevelData.get(0).length);

  manHeight=2*platformHeight-10;
  manWidth=(int)(manHeight/1.537);

  for (int i=0; i<stringLevelData.get(currentLevelNo).length; i++) {
    ArrayList<Platform> platforms;
    platforms = new ArrayList<Platform>();
    for (int q=0; q<stringLevelData.get(currentLevelNo)[i].length(); q++) {
      Platform platform= new Platform();
      platform.y=platformHeight*i;

      platform.x=platformHeight*q;

      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("L")) {
        platform.platformRobust=true;
        platform.platformType=0;
      }
      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("T")) {
        platform.platformRobust=true;
        platform.platformType=1;
      }
      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("N")) {
        platform.platformRobust=true;
        platform.platformType=2;
      }
      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("H")) {
        platform.platformRobust=true;
        platform.platformType=3;
      }
      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("U")) {
        platform.platformRobust=true;
        platform.platformType=4;
      }
      if (stringLevelData.get(currentLevelNo)[i].substring(q, q+1).equals("C")) {
        platform.platformRobust=true;
        platform.platformType=5;
      }
      platforms.add(platform);
      platform.xPosInArray=q;
      platform.yPosInArray=i;
    }
    levelData.add(platforms);
  }



  //-2 ist die magische Zahl (vermutlich der Rand des Rechtecks)
  newPlatformPosition=(stringLevelData.get(currentLevelNo)[0].length()-1)*platformHeight-2;





  addPlayer("la");

  //addPlayer("fr");


  //addPlayer("la");

  //addPlayer("fr");
  //addPlayer("sdf");




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
            currentLevelNo=(int)random(1, levelCount+1);
          }

          if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("L")) {
            platform.platformRobust=true;
            platform.platformType=0;
          }
          
          else if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("T")) {
            platform.platformRobust=true;
            platform.platformType=1;
          }
          else if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("N")) {
            platform.platformRobust=true;
            platform.platformType=2;
          }
          else if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("H")) {
            platform.platformRobust=true;
            platform.platformType=3;
          }
          else if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("U")) {
            platform.platformRobust=true;
            platform.platformType=4;
          }
          else if (stringLevelData.get(currentLevelNo)[platform.yPosInArray].substring(platform.xPosInArray, platform.xPosInArray+1).equals("C")) {
            platform.platformRobust=true;
            platform.platformType=5;
          } 
          else {
            platform.platformRobust=false;
          }
        }
      }
    }
  }

  for (Man man: spielFiguren) {
    man.simulateGravity();

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
  man.maximumRun= 0+spielFiguren.size()*5;

  if (spielFiguren.size()%2==0) {
    man.y=platformHeight+50;
    man.schwerkraft=1;
  }
  else {
    man.y=height/2; // -(platformHeight+50)
    man.schwerkraft=-1;
  }

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

