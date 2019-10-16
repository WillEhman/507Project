void drawSidebar() {
  stroke(0, 0, 0);
  fill(128, 128, 128);
  rect(500, 0, 200, 500);
  drawNetcuts(countNetcuts());
  if (nodeMode == true) {
    text("Node", 550, 30);
  }
  if (edgeMode == true) {
    text("Edge", 550, 30);
  }
  drawCellList();
}

void drawNodes() {
  for (int i = 0; i < nodes.length; i++) {
    drawNode(nodes[i]);
  }
}

void drawNode(Node node) {
  stroke(0, 0, 0);
  fill(255, 255, 255);
  circle(node.xpos, node.ypos, 50);
  textSize(25);
  fill(0, 0, 0);
  text(node.id, node.xpos-9, node.ypos+8);
}

void drawCellList(){
  char [] a = count_partition(partition_x1, true);
  String a_list = new String(a);
  
  char [] b = count_partition(partition_x1, false);
  String b_list = new String(a);
  
  text("A: " + a_list, 510, 400);
  text("B: " + b_list, 510, 450);
}

void drawNetcuts(int cuts) {
  textSize(25);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  text("NC: " + str(cuts), 550, 100);
}

void drawConnections() {
  if (nodes.length > 0) {
    for (int i = 0; i < nodes.length; i++) {
      Node currentNode = nodes[i];
      if (currentNode.connections.length >0) {
        for (int j = 0; j<currentNode.connections.length; j++) {
          stroke(0, 0, 0);
          line(currentNode.xpos, currentNode.ypos, nodes[findNode(currentNode.connections[j])].xpos, nodes[findNode(currentNode.connections[j])].ypos);
        }
      }
    }
  }
}

void drawPartition() {
  stroke(255, 0, 0);
  line(partition_x1, 0, partition_x1, 500); //Guarantees that line goes off screen in
}
