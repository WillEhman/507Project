//Establish the properties of the program window
void setup() {
  size(700, 500);
  frameRate(60);
  noCursor();
}

//Call the funcitons to draw on the program window
void draw() {
  //calculate the number of Net Cuts
  calculateGains();
  //If the optimize button has been pressed, run the optimization algorithm
  if (startOptimizing) {
    optimizeNetcuts();
  }
  //Draw the various parts of the User Interface
  drawBackground();
  drawPartition();
  drawEdgemaker();
  drawConnections();
  drawNodes();
  drawSidebar();
  drawButtons();
  drawCursor();
}

//NOTES:
//Should probably disable nodes/edges button after the optimization button is pressed -- Done
//Add a reset button that clears the work area -- Done
