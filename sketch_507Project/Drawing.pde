void drawBackground() {
  background(200);
}

void drawSidebar() {
  stroke(0, 0, 0);
  fill(128, 128, 128);
  rect(500, 0, 200, 500);
  netCuts = countNetcuts();
  drawNetcuts(netCuts);
  drawCellList();
  line(500,300,700,300);
  strokeWeight(10);
  stroke(64);
  line(520,360,680,360);
  textAlign(CENTER);
  text(str(balanceCriteria), balanceSlider.x+4, balanceSlider.y-2);
  strokeWeight(3);
  textAlign(LEFT);
}

void drawButtons(){
 for (int i = 0; i<buttons.length;i++){
   buttons[i].drawButton();
 }
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
  textSize(12);
  text(node.gain, node.xpos-6, node.ypos+18);
}

void drawCursor() {
  stroke(0, 0, 0);
  line(mouseX+5, mouseY, mouseX-5, mouseY);
  line(mouseX, mouseY-5, mouseX, mouseY+5);
}

void drawEdgemaker() {
  if (edgeMode) {
    if (!firstEdge) {
      stroke(255, 0, 0);
      line(firstNode.xpos, firstNode.ypos, mouseX, mouseY);
    }
  }
}

void drawCellList() {
  char [] a = count_partition(partition_x1, true);
  if (a.length>13) {
    a = splice(a, '\n', 13);
  }
  String a_list = new String(a);

  char [] b = count_partition(partition_x1, false);
  if (b.length>13) {
    b = splice(b, '\n', 13);
  }
  String b_list = new String(b);
  textSize(14); 
  text("A: " + a_list, 510, 430);
  text("B: " + b_list, 510, 470);
}

void drawNetcuts(int cuts) {
  textSize(25);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  text("NC: " + str(cuts), 550, 330);
}

void drawConnections() {
  if (nodes.length > 0) {
    for (int i = 0; i < connections.length; i++) {
      stroke(0, 0, 0);
      line(connections[i].node1.xpos, connections[i].node1.ypos, connections[i].node2.xpos, connections[i].node2.ypos);
      textSize(16);
      fill(0, 0, 0);
      text(connections[i].weight, ((connections[i].node2.xpos-connections[i].node1.xpos)/2)+connections[i].node1.xpos, ((connections[i].node2.ypos-connections[i].node1.ypos)/2)+connections[i].node1.ypos-3);
    }
  }
}

void drawPartition() {
  stroke(255, 0, 0);
  line(partition_x1, 0, partition_x1, 500); //Guarantees that line goes off screen in
  textSize(150);
  fill(128, 128, 128);
  text("A", 75, 300);  //Labels to show the two partitions
  text("B", 325, 300);
}
