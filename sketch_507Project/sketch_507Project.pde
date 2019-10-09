class Node { 
  float xpos, ypos; 
  char id;
  char [] connections = new char[0];
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
  }

  void addConnection(char new_node) {
    connections = (char[])append(connections, new_node);
  }
}

boolean nodeMode = true;
Node[] nodes = new Node[0];
int partition_x1, partition_x2;

void setup() {
  size(700, 500);
  frameRate(30);
  partition_x1 = int(random(100, 400));
  partition_x2 = int(random(100, 400));
}

void draw() {
  drawConnections();
  for (int i = 0; i < nodes.length; i++) {
    drawNode(nodes[i]);
  }
  drawPartition();
  drawSidebar();
}

void mousePressed() {
  if (nodeMode) {
    //TODO handle more than 26 nodes
    if (mouseX<500) {
      Node newNode = new Node(mouseX, mouseY, char(nodes.length + 65));

      if (nodes.length > 0) {
        newNode.addConnection(char(nodes.length + 64));
      }

      nodes = (Node[])append(nodes, newNode);
    }
  }
}

void drawPartition() {
  stroke(255, 0, 0);
  line(partition_x1, 0, partition_x2, 500); //Guarantees that line goes off screen in
}

void drawNode(Node node) {
  stroke(0, 0, 0);
  fill(255, 255, 255);
  circle(node.xpos, node.ypos, 50);
  textSize(25);
  fill(0, 0, 0);
  text(node.id, node.xpos-9, node.ypos+8);
}

void drawConnections() {
  if (nodes.length > 0) {
    for (int i = 1; i < nodes.length; i++) {
      stroke(0, 0, 0);
      line(nodes[i-1].xpos, nodes[i-1].ypos, nodes[i].xpos, nodes[i].ypos);
    }
  }
}

void drawSidebar() {
  stroke(0, 0, 0);
  fill(128, 128, 128);
  rect(500, 0, 200, 500);
  drawNetcuts(countNetcuts());
}

void drawNetcuts(int cuts) {
  textSize(25);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  text("NC: " + str(cuts), 550, 100);
}

int countNetcuts() {
  int cuts = 0;
  if (nodes.length > 0) {
    for (int i = 1; i < nodes.length; i++) {
      //Algorithm http://jeffreythompson.org/collision-detection/line-line.php
      float x1 = nodes[i-1].xpos;
      float x2 = nodes[i].xpos;
      float y1 = nodes[i-1].ypos;
      float y2 = nodes[i].ypos;
      
      float x3 = partition_x1;
      float x4 = partition_x2;
      float y3 = 0;
      float y4 = 500;
      
      float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        cuts++;
      }
    }
  }
  return cuts;
}
