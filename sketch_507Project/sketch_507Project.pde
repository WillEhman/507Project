void setup() {
  size(700, 500);
  frameRate(60);
  noCursor();
}

void draw() {
  calculateGains();
  drawBackground();
  drawPartition();
  drawEdgemaker();
  drawConnections();
  drawNodes();
  drawSidebar();
  drawButtons();
  drawCursor();
}
