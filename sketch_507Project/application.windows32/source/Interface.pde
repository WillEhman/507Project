void mousePressed() {
  if (modeSwap.isPressed(mouseX, mouseY) && noMoreNodes == false) {
    swapModes();
  }
  if (optimize.isPressed(mouseX, mouseY)) {
    startOptimizing = true;
    startTime=millis();
    modeSwap.textColor = 128;
    noMoreNodes = true;
  }
  if (step.isPressed(mouseX, mouseY)) {
    stepOptimize();
    modeSwap.textColor = 128;
    noMoreNodes = true;
  }
  if (reset.isPressed(mouseX, mouseY)) {
    reset();
  }
  if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && lowerBalanceSlider.x <= 680 && lowerBalanceSlider.x >= 520 && mouseX+5 < upperBalanceSlider.x && mouseX+5 < 600) {
    lowerBalanceSlider.x = mouseX-5;
    lowerBalanceCriteria = (lowerBalanceSlider.x-520)*100/160;
  }
  if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && upperBalanceSlider.x <= 680 && upperBalanceSlider.x >= 520 && mouseX-5 > lowerBalanceSlider.x && mouseX+5 > 600) {
    upperBalanceSlider.x = mouseX-5;
    upperBalanceCriteria = (upperBalanceSlider.x-520)*100/160;
  }
  if (mouseX<500 && !noMoreNodes) {
    if (nodeMode) {
      createNodes();
    }
    if (edgeMode) { //edgeMode
      createEdges();
    }
  }
}

void swapModes() {
  if (nodeMode == true) {
    nodeMode = false;
    edgeMode = true;
    modeSwap.text = "Edge";
  } else if (edgeMode == true) {
    edgeMode = false;
    nodeMode = true;
    modeSwap.text = "Node";
  }
}

void createNodes() {

  if (clickedOnNode(mouseX, mouseY, 50).id == '?' && nodes.length < 26 && (mouseX < (partition_x1-25) || mouseX > (partition_x1+25))) { //If we didnt click on a node
    Node newNode = new Node(mouseX, mouseY, char(nodes.length + 65));
    nodes = (Node[])append(nodes, newNode);
  }
}

void createEdges() {
  Node selectedNode = clickedOnNode(mouseX, mouseY, 25);
  if (selectedNode.id != '?') {
    if (firstEdge) {
      firstNode = selectedNode;
      firstEdge = false;
    } else {
      int exists = connectionExists(firstNode, selectedNode);
      if (exists != -1) {
        connections[exists].weight++;
      } else {
        connections = (Connection[])append(connections, new Connection(firstNode, selectedNode));
      }
      firstEdge=true;
    }
  }
}


Node clickedOnNode(int x, int y, int range) {
  int i;
  for (i=0; i<nodes.length; i++) {
    if ((x<=(nodes[i].xpos + range) && x>=(nodes[i].xpos - range)) && (y<=(nodes[i].ypos +range) && y>=(nodes[i].ypos - range))) {
      return nodes[i];
    }
  }
  Node error = new Node(-1, -1, '?');
  return error;
}
