void mousePressed() {
  if (mouseX>500) {
    if (nodeMode == true) {
      nodeMode = false;
      edgeMode = true;
    } else if (edgeMode == true) {
      edgeMode = false;
      nodeMode = true;
    }
  }
  if (nodeMode) {
    //TODO handle more than 26 nodes
    if (mouseX<500) {
      if (clickedOnNode(mouseX, mouseY, 50).id == '?' && nodes.length < 26 && (mouseX < (partition_x1-25) || mouseX > (partition_x1+25))) { //If we didnt click on a node
        Node newNode = new Node(mouseX, mouseY, char(nodes.length + 65));
        nodes = (Node[])append(nodes, newNode);
      }
    }
  }
  if (edgeMode) { //edgeMode
    if (mouseX<500) {
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
