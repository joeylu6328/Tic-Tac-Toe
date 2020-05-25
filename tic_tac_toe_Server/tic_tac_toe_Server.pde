import processing.net.*;

color green = #A0B046;
color orange = #F78145;

boolean myTurn= true;
int win;

Server myServer; 
int[][] grid;

void setup() {
  size(300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myServer = new Server(this, 1234);
  win = 0;
}

void draw() {
   
   if(win != 0){
     background(0);
     if(win == 1){
       fill(255);
       text("Server lost",150,200);
     }
     else if(win == 2){
       fill(255);
       text("Server won",150,200);
     }
     
   }
   else{
      if (myTurn)
        background(green);
      else 
        background(orange);
        
      stroke(0);
      line(0, 100, 300, 100);
      line(0, 200, 300, 200);
      line(100, 0, 100, 300);
      line(200, 0, 200, 300);
      
      for(int row = 0; row < 3; row++){
        for(int col = 0; col < 3; col++){
          drawXO(row, col);
        }
      }
      
      fill(0);
      text(mouseX + "," + mouseY, 150, 350);
   }
   
  
  for(int i = 0; i < 3; i++){
    if(grid[i][0]==grid[i][1]&&grid[i][1]==grid[i][2]&&grid[i][0]==2||grid[0][i]==grid[1][i]&&grid[0][i]==grid[2][i]&&grid[0][i]==2){
      win = 2;
    }
    else if(grid[i][0]==grid[i][1]&&grid[i][1]==grid[i][2]&&grid[i][0]==1||grid[0][i]==grid[1][i]&&grid[0][i]==grid[2][i]&&grid[0][i]==1){
      win = 1;
    }
  }
  if(grid[0][0]==grid[1][1]&&grid[1][1]==grid[2][2]&&grid[1][1]==2||grid[0][2]==grid[1][1]&&grid[1][1]==grid[2][0]&&grid[1][1]==2){
    win = 2;
  }
  else if(grid[0][0]==grid[1][1]&&grid[1][1]==grid[2][2]&&grid[1][1]==1||grid[0][2]==grid[1][1]&&grid[1][1]==grid[2][0]&&grid[1][1]==1){
    win = 1;
  }
  

 
  
  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r = int(incoming.substring(0,1));
    int c = int(incoming.substring(2,3));
    grid[r][c] = 1;
    myTurn = true;
  }
  
}

void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    noFill();
    ellipse(50, 50, 90, 90);
  } 
  else if (grid[row][col] == 2) {
    line (10, 10, 90, 90);
    line (90, 10, 10, 90);
  }
  popMatrix();
}

void mouseReleased() {
  int row = mouseX/100;
  int col = mouseY/100;
  if (myTurn && grid[row][col] == 0) {
    myServer.write(row + "," + col); 
    grid[row][col] = 2;
    myTurn = false;
  }
}
