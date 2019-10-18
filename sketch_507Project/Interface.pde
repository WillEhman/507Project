void mousePressed() {
  if (modeSwap.isPressed(mouseX, mouseY)) {
    swapModes();
  }
  if (optimize.isPressed(mouseX, mouseY)) {
    optimizeNetcuts();
  }
  if (step.isPressed(mouseX, mouseY)) {
    //stepOptimize();
  }
  if (reset.isPressed(mouseX, mouseY)) {
    reset();
  }
  if (mouseX<500) {
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
