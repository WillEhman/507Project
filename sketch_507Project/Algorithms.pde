void calculateGains() {
  for (int i = 0; i<nodes.length; i++) {
    nodes[i].calculateGain();
  }
}

//void optimizeNetcuts() {
//  //Save the 0th iteration
//  println("Starting optimizations!");
//  save = (Iteration[])append(save, new Iteration());
//  //Compute Gain of all nodes
//  calculateGains();
//  //Find highest gain node that isn't fixed
//  int highestNode = findHighestGain();
//  //while (highestNode != -1) { //If it is ? then we are done
//  //Move chosen node and set to fixed
//  nodes[highestNode] = swapPartition(nodes[highestNode]);
//  nodes[highestNode].isFixed = true;
//  //Update the gains of all nodes
//  calculateGains();
//  //Update the net cuts -- Done automatically
//  //Save the new iteration
//  save = (Iteration[])append(save, new Iteration());
//  highestNode = findHighestGain();
//  // }
//}

void optimizeNetcuts() { 
  //Save the 0th iteration
  println("Starting optimizations!");
  save = (Iteration[])append(save, new Iteration());
  //Compute Gain of all nodes
  calculateGains();
  //Find highest gain node that isn't fixed
  int highestNode = findHighestGain();
  if (highestNode != -1) {
    //while (highestNode != -1) { //If it is ? then we are done
    //Move chosen node and set to fixed
    nodes[highestNode] = swapPartition(nodes[highestNode]);
    nodes[highestNode].isFixed = true;
    //Update the gains of all nodes
    calculateGains();
    //Update the net cuts -- Done automatically
    //Save the new iteration
    //save = (Iteration[])append(save, new Iteration());
    println(save.length);
    highestNode = findHighestGain();
  } else {
    println("restoring");
    save[0].load();
  }
}

Node swapPartition(Node node) {
  int low, high;
  if (node.partition == 'A') {
    low = 250;
    high = 500;
  } else {
    low = 0;
    high = 250;
  }
  boolean not_found_spot = true;
  int rand_xpos = 0;
  int rand_ypos = 0;
  while (not_found_spot) {
    rand_xpos = (int)random(low, high);
    rand_ypos = (int)random(0, 500);
    not_found_spot = false;
    if (clickedOnNode(rand_xpos, rand_ypos, 25).id != '?') {
      println(clickedOnNode(rand_xpos, rand_ypos, 25).id);
      not_found_spot = true;
    }
  }
  //TODO Fix it so it wont break if it can't find a spot
  node.xpos = rand_xpos;
  node.ypos = rand_ypos;
  return node;
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
      } else {
        connections[i].cut = false;
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

int findHighestGain() {
  //Simple funciton for finding node with the highest gain
  int highestIndex = -1;
  int highestGain = -9999999;
  for (int i = 0; i < nodes.length; i++) {
    if (nodes[i].gain > highestGain && nodes[i].isFixed == false) {
      highestGain = nodes[i].gain;
      highestIndex = i;
    }
  }
  if (highestIndex != -1)
    return highestIndex;
  else
    return -1;
}
