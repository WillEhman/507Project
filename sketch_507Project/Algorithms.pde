void calculateGains() {
  for (int i = 0; i<nodes.length; i++) {
    nodes[i].calculateGain();
  }
}

void optimizeNetcuts(){
  //Save the 0th iteration
  iteration
  //Compute Gain of all nodes -- Done automatically
  //Find highest gain node that isn't fixed
  Node highestNode = findHighestGain();
  while (highestNode.id != '?'){ //If it is ? then we are done
    //Move chosen node and set to fixed
    swapPartition(highestNode);
    highestNode.isFixed = true;
    //Update the gains of all nodes -- Done automatically
    //Update the net cuts -- Done automatically
  }
}

int connectionExists(Node x, Node y) {
  for (int i = 0; i<connections.length; i++) {
    if ((connections[i].node1.id == x.id && connections[i].node2.id == y.id) || (connections[i].node2.id == x.id && connections[i].node1.id == y.id)) {
      return i;
    }
  }
  return -1;
}

int countNetcuts() {
  int cuts = 0;
  if (nodes.length > 0) {
    for (int i = 0; i < connections.length; i++) {
      //Algorithm http://jeffreythompson.org/collision-detection/line-line.php
      Node node1 = connections[i].node1;
      Node node2 = connections[i].node2;
      float x1 = node1.xpos;
      float x2 = node2.xpos;
      float y1 = node1.ypos;
      float y2 = node2.ypos;

      float x3 = partition_x1;
      float x4 = partition_x1;
      float y3 = 0;
      float y4 = 500;

      float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        cuts+=connections[i].weight;
        connections[i].cut = true;
      }
    }
  }
  return cuts;
}

int findNode(char c) {
  for (int i = 0; i<nodes.length; i++) {
    if (nodes[i].id == c) {
      return i;
    }
  }
  return -1;
}

char [] count_partition(int x, boolean less_than) {
  char [] cells = {};
  for (int i = 0; i < nodes.length; i++) {
    if (less_than) {
      if (nodes[i].xpos <= x) {
        cells = append(cells, nodes[i].id);
      }
    } else {
      if (nodes[i].xpos > x) {
        cells = append(cells, nodes[i].id);
      }
    }
  }
  return cells;
}

Node findHighestGain(){
  //Simple funciton for finding node with the highest gain
  int highestIndex = -1;
  int highestGain = nodes[0].gain;
  for (int i = 0; i < nodes.length; i++){
    if (nodes[i].gain > highestGain && nodes[i].isFixed == false){
      highestGain = nodes[i].gain;
      highestIndex = i;
    }
  }
  if (highestIndex != -1)
    return nodes[highestIndex];
  else
    return new Node(-1, -1, '?');
  
}
