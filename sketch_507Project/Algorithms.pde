//Calculate the gain for all nodes
void calculateGains() {
  //Iterate through each node and calculate the gain
  for (int i = 0; i<nodes.length; i++) {
    nodes[i].calculateGain();
  }
}

//Calculate the gain for all nodes
void calculateCPUGains() {
  //Iterate through each node and calculate the gain
  for (int i = 0; i<computernodes.length; i++) {
    computernodes[i].calculateCPUGain();
  }
}

void findBestScore() {
  startedGame=true;
  Iteration initialsave = new Iteration(computernodes);
  while (startedGame) {
    optimizeNetcuts(true);
  }
  bestSave = new Iteration(computernodes); 
  initialsave.load();
  bestScore.text = str(bestNetCut);
  startedGame=false;
}

//Step through the optimization algorithm once per second
//Runs the optimization algorithm to completion
void optimizeNetcuts(int speed) {
  //Step through the optimization once every second
  if ((millis()-startTime) > speed) {
    stepOptimize(false);
    startTime = millis();
  }
}

void optimizeNetcuts(boolean is_initial) {
  //Step through the optimization as fast as possible
  CPUnetCuts = countNetcuts(computernodes, cpuconnections);
  stepOptimize(is_initial);
}

//The optimization algorithm -- FM net cut optimization
//Only performs one iteration of the FM algorithm
void stepOptimize(boolean is_initial) { 
  //Save the iteration
  save = (Iteration[])append(save, new Iteration(computernodes));
  //Compute Gain of all nodes
  calculateCPUGains();
  //Find highest gain node that isn't fixed
  int highestNode = findHighestGain();
  if (highestNode != -1) {//If it is -1 then no more unfixed nodes
    //Move chosen node and set to fixed
    computernodes[highestNode] = swapPartition(computernodes[highestNode]);
    computernodes[highestNode].isFixed = true;
    //Update the gains of all nodes
    calculateCPUGains();
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
    bestNetCut = save[bestIter].cuts;
    //End optimization
    startOptimizing = false;
    if (is_initial){
      startedGame=false;
    }
  }
}

//Function to swap the partition a node is in (A->B or B->A)
Node swapPartition(Node node) {
  //identify the upper and lower bounds for moving the node
  int low, high;
  if (node.partition == 'A') {
    low = 3*width/4+25;
    high = width-25;
  } else {
    low = width/2+25;
    high = 3*width/4-25;
  }

  //Find a new spot in the othe partition for the node
  boolean not_found_spot = true;
  int rand_xpos = 0;
  int rand_ypos = 0;
  //Keep trying until a spot is found
  while (not_found_spot) {
    rand_xpos = (int)random(low, high);
    rand_ypos = (int)random(25, height-25);
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
int countNetcuts(Node[] nodearray, Connection[] connectionarray) {
  int cuts = 0;
  //Run algorithm if there are nodes
  if (nodearray.length > 0) {
    //Run for each nodes
    for (int i = 0; i < connectionarray.length; i++) {
      //Algorithm http://jeffreythompson.org/collision-detection/line-line.php
      //Checks to see if two lines intersect, in this case the partition divider and an edge
      Node node1 = connectionarray[i].node1;
      Node node2 = connectionarray[i].node2;

      Point p1 = new Point(int(node1.xpos), int(node1.ypos));
      Point p2 = new Point(int(node2.xpos), int(node2.ypos));
      Point p3 = new Point(partition_x1, 0);
      Point p4 = new Point(partition_x1, height);

      //If an edge intersects the patition divider, there is a cut
      if (checkIntersection(p1, p2, p3, p4)) {
        cuts+=1;
        connectionarray[i].cut = true;
      } else {
        connectionarray[i].cut = false;
      }
    }
  }
  //Return the number of cuts found
  return cuts;
}

//Function to count the net cuts
int countNetcuts(Node[] nodearray, Connection[] connectionarray, Point[] pointarray) {
  int cuts = 0;
  //Run algorithm if there are nodes
  if (nodearray.length > 0) {
    //Run for each nodes
    for (int i = 0; i < connectionarray.length; i++) {
      for (int j = 1; j < pointarray.length; j++) {

        Node node1 = connectionarray[i].node1;
        Node node2 = connectionarray[i].node2;

        Point p1 = new Point(int(node1.xpos), int(node1.ypos));
        Point p2 = new Point(int(node2.xpos), int(node2.ypos));
        Point p3 = pointarray[j-1];
        Point p4 = pointarray[j];

        //If an edge intersects the patition divider, there is a cut
        if (checkIntersection(p1, p2, p3, p4)) {
          cuts+=1;
          connectionarray[i].cut = true;
        } else {
          connectionarray[i].cut = false;
        }
      }
    }
  }
  //Return the number of cuts found
  return cuts;
}
//Algorithm http://jeffreythompson.org/collision-detection/line-line.php
//Checks to see if two lines intersect, in this case the partition divider and an edge
boolean checkIntersection(Point a, Point b, Point c, Point d) {
  float x1 = a.xpos;
  float x2 = b.xpos;
  float y1 = a.ypos;
  float y2 = b.ypos;
  float x3 = c.xpos;
  float x4 = d.xpos;
  float y3 = c.ypos;
  float y4 = d.ypos;

  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
  }
  return false;
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
    if (computernodes[i].gain > highestGain && computernodes[i].isFixed == false) {
      highestGain = computernodes[i].gain;
      highestIndex = i;
    }
  }
  if (highestIndex != -1)
    return highestIndex;
  else
    return -1;
}

void createRandomNodes(int nodecount) {
  for (int i=0; i< nodecount; ) {
    float randomX = random(0, width/2);
    float randomY = random(0, height);
    if (clickedOnNode((int)randomX, (int)randomY, 100).id == '?' && randomX < ((width/2)-100) && randomX > 50 && (randomX < ((width/4)-50) || randomX > ((width/4)+50)) && randomY < (height-50) && randomY > 50) { //Check if we clicked in an occupied space
      Node newNode = new Node(randomX, randomY, char(i+65));
      //Add the node to the list of nodes
      nodes = (Node[])append(nodes, newNode);
      Node newCPUNode = new Node(randomX+(width/2), randomY, char(i+97));
      computernodes = (Node[])append(computernodes, newCPUNode);
      i++;
    }
  }
}

void createRandomEdges(int edgecount) {
  for (int i=0; i< edgecount; i++) {
    int randomi = (int)random(0, nodes.length);
    createEdges((int)nodes[randomi].xpos, (int)nodes[randomi].ypos);
  }
}
