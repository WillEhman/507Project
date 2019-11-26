//Establish the properties of the program window
void setup() {
  size(1200, 800);
  frameRate(120);
  noCursor();
  createRandomNodes(5);
  createRandomEdges(30);
  findBestScore();
}

//Call the funcitons to draw on the program window
void draw() {
  drawGameLayout();

  ////calculate the number of Net Cuts
  calculateGains();
  calculateCPUGains();

  //If player is done
  if (doneDrawingPartition && playerPartition.length > 1) {
    determineVictory();
  }


  //TODO handle if CPU finishes first
  if (!startOptimizing && startedGame ){
    showPlayerVictory(false);
  }

  //RUN CPU AI
  ////If the start button has been pressed, run the optimization algorithm
  if (startOptimizing) {
    optimizeNetcuts(1000);
  }


  ////Draw the various parts of the User Interface
  drawPartition();
  drawPlayerPartition();
  drawConnections();
  drawCPUConnections();
  drawNodes();
  drawButtons();
  drawCursor();
  drawCPUScore();
  drawPlayerScore();
}

//Pallette
//https://coolors.co/1c333d-0d7170-2a9e5c-9ddbb8-d4f4dd
//$color1: rgba(28, 51, 61, 1); dark blue (backgrounds)
//$color2: rgba(13, 113, 112, 1); lighter dark blue (background details)
//$color3: rgba(42, 158, 92, 1); dark green (node outline)
//$color4: rgba(157, 219, 184, 1); light green (node fill)
//$color5: rgba(212, 244, 221, 1); light aqua (text)
