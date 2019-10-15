void setup() {
  size(700, 500);
  frameRate(60);
}

void draw() {
  drawConnections();
  drawNodes();
  drawPartition();
  drawSidebar();
}
