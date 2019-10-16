void setup() {
  size(700, 500);
  frameRate(60);
  noCursor();
}

void draw() {
  drawBackground();
  drawPartition();
  drawEdgemaker();
  drawConnections();
  drawNodes();
  drawSidebar();
  drawCursor();
}
