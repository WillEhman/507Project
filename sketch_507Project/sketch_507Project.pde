void setup() {
  size(700, 500);
  frameRate(60);
}

void draw() {
  drawBackground();
  drawConnections();
  drawEdgemaker();
  drawPartition();
  drawNodes();
  drawSidebar();
  drawCursor();
}
