void setup() {
  size(700, 500);
  frameRate(60);
  noCursor();
}

void draw() {
  calculateGains();
  if (startOptimizing){
    optimizeNetcuts();
  }
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
//Should probably disable nodes/edges button after the optimization button is pressed
//Add a reset button that clears the work area
