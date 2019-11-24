//Calculate the gain for all nodes
void calculateGains() {
  //Iterate through each node and calculate the gain
  for (int i = 0; i<nodes.length; i++) {
    nodes[i].calculateGain();
  }
}

//Step through the optimization algorithm once per second
//Runs the optimization algorithm to completion
void optimizeNetcuts() {
  //Step through the optimization once every second
  if ((millis()-startTime) > 1000) {
    stepOptimize();
    startTime = millis();
  }
}

//The optimization algorithm -- FM net cut optimization
//Only performs one iteration of the FM algorithm
void stepOptimize() { 
  //Save the iteration
  save = (Iteration[])append(save, new Iteration());
  //Compute Gain of all nodes
  calculateGains();
  //Find highest gain node that isn't fixed
  int highestNode = findHighestGain();
  if (highestNode != -1) {//If it is -1 then no more unfixed nodes
    //Move chosen node and set to fixed
    nodes[highestNode] = swapPartition(nodes[highestNode]);
    nodes[highestNode].isFixed = true;
    //Update the gains of all nodes
    calculateGains();
    //Update the net cuts -- Done automatically
    highestNode = findHighestGain();
  } else {
    //Find the best iteration (lowest net cut)
    int temp = 9999999;
    int bestIter = -1;
    for (int i = 0; i < save.length; i++) {
      if (save[i].cuts < temp && save[i].isBalanced) { //If it is better and balanced, make it the best iteration
        temp = save[i].cuts;
        bestIter = i;
      }
    }
    //load the best iteration
    save[bestIter].load();
    //End optimization
    startOptimizing = false;
  }
}

//Function to swap the partition a node is in (A->B or B->A)
Node swapPartition(Node node) {
  //identify the upper and lower bounds for moving the node
  int low, high;
  if (node.partition == 'A') {
    low = 275;
    high = 475;
  } else {
    low = 25;
    high = 225;
  }
  
  //Find a new spot in the othe partition for the node
  boolean not_found_spot = true;
  int rand_xpos = 0;
  int rand_ypos = 0;
  //Keep trying until a spot is found
  while (not_found_spot) {
    rand_xpos = (int)random(low, high);
    rand_ypos = (int)random(25, 475);
    not_found_spot = false;
    //If the spot has a node in it, reject it
    if (clickedOnNode(rand_xpos, rand_ypos, 50).id != '?') {
      not_found_spot = true;
    }
  }
  //Assign the new spot to the node
  node.xpos = rand_xpos;
  node.ypos = rand_ypos;
  return node;
}

//Simple function to see how many connections exist between 2 nodes
int connectionExists(Node x, Node y) {
  for (int i = 0; i<connections.length; i++) {
    if ((connections[i].node1.id == x.id && connections[i].node2.id == y.id) || (connections[i].node2.id == x.id && connections[i].node1.id == y.id)) {
      return i;
    }
  }
  return -1;
}

//Function to count the net cuts
int countNetcuts() {
  int cuts = 0;
  //Run algorithm if there are nodes
  if (nodes.length > 0) {
    //Run for each nodes
    for (int i = 0; i < connections.length; i++) {
      //Algorithm http://jeffreythompson.org/collision-detection/line-line.php
      //Checks to see if two lines intersect, in this case the partition divider and an edge
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
      
      //If an edge intersects the patition divider, there is a cut
      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        cuts+=connections[i].weight;
        connections[i].cut = true;
      } else {
        connections[i].cut = false;
      }
    }
  }
  //Return the number of cuts found
  return cuts;
}

//Find a node with a given label
int findNode(char c) {
  for (int i = 0; i<nodes.length; i++) {
    if (nodes[i].id == c) {
      return i;
    }
  }
  return -1;
}

//Count the number of nodes in a partition
char [] count_partition(int x, boolean less_than) {
  char [] cells = {};
  //Iterate through all the nodes
  for (int i = 0; i < nodes.length; i++) {
    //If we should check to the left or right of the partition divider
    if (less_than) {
      //Check if the node exists in the desired partiton
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

//Simple funciton for finding node with the highest gain
int findHighestGain() {
  int highestIndex = -1;
  int highestGain = -9999999;
  //Iterate through each node 
  for (int i = 0; i < nodes.length; i++) {
    //If the node has a higher gain than the previous then make it the new highest
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

void createRandomNodes(int nodecount){
  for (int i=0; i< nodecount;){
    float randomX = random(0,width/2);
    float randomY = random(0,height);
    if (clickedOnNode((int)randomX, (int)randomY, 100).id == '?' && randomX < ((width/2)-50) && randomX > 50 && (randomX < ((width/4)-50) || randomX > ((width/4)+50)) && randomY < (height-50) && randomY > 50) { //Check if we clicked in an occupied space
      Node newNode = new Node(randomX, randomY);
      //Add the node to the list of nodes
      nodes = (Node[])append(nodes, newNode);
      Node newCPUNode = new Node(randomX+(width/2), randomY);
      computernodes = (Node[])append(computernodes, newCPUNode);
      i++;
    }
  }
}

void createRandomEdges(int edgecount){
  for (int i=0; i< edgecount;i++){
    int randomi = (int)random(0,nodes.length);
    createEdges((int)nodes[randomi].xpos,(int)nodes[randomi].ypos);
  }
}
