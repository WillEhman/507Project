//Built-in Processing function to check if the mouse has been pressed
void mousePressed() {
  switch(ProgramState) {
  case 0: //Menu case
    if (play.isPressed(mouseX, mouseY)) {
      ProgramState = 2;
    } else if (rules.isPressed(mouseX, mouseY)){
      ProgramState = 1;
    }
    break; //End of Menu case
  case 1: //Rules case
    if (mainMenu.isPressed(mouseX, mouseY)){
      ProgramState = 0;
    }
    break; //End of Rules case
  case 2: //Game case
    ////Has the swap modes button been pressed?
    //if (modeSwap.isPressed(mouseX, mouseY) && noMoreNodes == false) {
    //  //Swap modes
    //  swapModes();
    //}

    ////Has the optimize button been pressed?
    //if (optimize.isPressed(mouseX, mouseY)) {
    //  startOptimizing = true;
    //  startTime=millis();
    //  modeSwap.textColor = 128; //Grey out the mode swap button
    //  noMoreNodes = true; //Disable drawing nodes
    //}

    //Has the step button been pressed?
    if (start.isPressed(mouseX, mouseY)) {
      startGame();
    }

    //Has the reset button been pressed?
    if (reset.isPressed(mouseX, mouseY)) {
      //Reset the program
      reset();
    }

    ////Does the lower bound slider need to be moved?
    //if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && lowerBalanceSlider.x <= 680 && lowerBalanceSlider.x >= 520 && mouseX+5 < upperBalanceSlider.x && mouseX+5 < 600) {
    //  //Move the slider
    //  lowerBalanceSlider.x = mouseX-5;
    //  lowerBalanceCriteria = (lowerBalanceSlider.x-520)*100/160;
    //}

    ////Does the upper bound slider need to be moved?
    //if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && upperBalanceSlider.x <= 680 && upperBalanceSlider.x >= 520 && mouseX-5 > lowerBalanceSlider.x && mouseX+5 > 600) {
    //  //Move the slider
    //  upperBalanceSlider.x = mouseX-5;
    //  upperBalanceCriteria = (upperBalanceSlider.x-520)*100/160;
    //}

    ////Should we draw a node or edge?
    //if (mouseX<width/2 && !noMoreNodes) { //Are we allowed to draw nodes/edges?
    //  if (nodeMode) {
    //    //Create a node centered at the cursor
    //    createNodes();
    //  }
    //  if (edgeMode) { //edgeMode
    //    //Create an edge end at the clicked node
    //    createEdges(mouseX, mouseY);
    //  }
    //}

    //Did the mouse click a free space on the Player side?
    if (startedGame) {
      if (mouseX > 0 && mouseX < width/2 && clickedOnNode(mouseX, mouseY, 25).id == '?' && !start.isPressed(mouseX, mouseY)) {
        boolean intersectsSelf = false;
        Point currentPoint = new Point(mouseX, mouseY);
        for (int i = 1; i < playerPartition.length - 1; i++) {
          if (checkIntersection(playerPartition[i-1], playerPartition[i], playerPartition[playerPartition.length-1], currentPoint)) {
            intersectsSelf = true; 
            break;
          }
        }
        if (!intersectsSelf) {
          if (playerPartition.length == 0) {
            playerPartition = (Point[])append(playerPartition, new Point(mouseX, 0));
          }
          if (isSamePos(lastX, mouseX, lastY, mouseY, 10) && !doneDrawingPartition) {
            doneDrawingPartition = true;
            playerPartition = (Point[])append(playerPartition, new Point(mouseX, height));
          }
          if (!doneDrawingPartition) {
            playerPartition = (Point[])append(playerPartition, new Point(mouseX, mouseY));
          }
        }
        lastX = mouseX;
        lastY = mouseY;
      }
    } else {
      if (mouseX > 0 && mouseX < width/2 && clickedOnNode(mouseX, mouseY, 25).id == '?' && !start.isPressed(mouseX, mouseY)) {
        if (isSamePos(lastX, mouseX, lastY, mouseY, 10) && !doneDrawingPartition) {
          doneDrawingPartition = true;
        }
      }
      lastX = mouseX;
      lastY = mouseY;
    }
    break; //End of Game case
  }
}

//Function to swap the mode
void swapModes() {
  if (nodeMode == true) { //Change to edge mode
    nodeMode = false;
    edgeMode = true;
    //modeSwap.text = "Edge";
  } else if (edgeMode == true) { //Change to node mode
    edgeMode = false;
    nodeMode = true;
    //modeSwap.text = "Node";
  }
}

//Function to create new nodes
void createNodes() {
  if (clickedOnNode(mouseX, mouseY, 50).id == '?' && nodes.length < 26 && (mouseX < (partition_x1-25) || mouseX > (partition_x1+25))) { //Check if we clicked in an occupied space
    //Create the new node
    Node newNode = new Node(mouseX, mouseY, char(nodes.length + 65));
    //Add the node to the list of nodes
    nodes = (Node[])append(nodes, newNode);
    Node newCPUNode = new Node(mouseX+width/2, mouseY, char(nodes.length + 65));
    //Add the node to the list of nodes
    computernodes = (Node[])append(computernodes, newCPUNode);
  }
}

//Function to create new edges
void createEdges(int x, int y) {
  //Make the clicked on node the selected node
  Node selectedNode = clickedOnNode(x, y, 25);
  Node selectedCPUNode = clickedOnCPUNode(x+width/2, y, 25);
  //Does the selected node exist?
  if (selectedNode.id != '?') {

    //Is the node the first of the pair
    if (firstEdge) {
      firstNode = selectedNode;
      firstEdge = false;
      firstCPUNode = selectedCPUNode;
    } else {
      //Is the clicked node not the same as the previous one?
      if (selectedNode.id != firstNode.id) {
        int exists = connectionExists(firstNode, selectedNode);
        //Does the connection already exist?
        if (exists != -1) {
          //Increase the weight of the connection
          //connections[exists].weight++;
        } else {
          //Create a new connection and add it to the list of connections
          connections = (Connection[])append(connections, new Connection(firstNode, selectedNode));
          cpuconnections = (Connection[])append(cpuconnections, new Connection(firstCPUNode, selectedCPUNode));
        }
        firstEdge=true;
      }
    }
  }
}

//void createCPUEdges(int x, int y) {
//  //Make the clicked on node the selected node
//  Node selectedCPUNode = clickedOnCPUNode(x, y, 25);
//  //Does the selected node exist?
//  if (selectedCPUNode.id != '?') {
//    //Is the node the first of the pair
//    if (firstCPUEdge) {
//      firstCPUNode = selectedCPUNode;
//      firstCPUEdge = false;
//    } else {
//      //Is the clicked node not the same as the previous one?
//      if (selectedCPUNode.id != firstCPUNode.id) {
//        int exists = connectionExists(firstCPUNode, selectedCPUNode);
//        //Does the connection already exist?
//        if (exists != -1) {
//          //Increase the weight of the connection
//          //connections[exists].weight++;
//        } else {
//          //Create a new connection and add it to the list of connections
//          println("creating edge for CPU: ", x, y);
//          cpuconnections = (Connection[])append(cpuconnections, new Connection(firstCPUNode, selectedCPUNode));
//        }
//        firstCPUEdge=true;
//      }
//    }
//  }
//}

//Function to determine what node was clicked on
Node clickedOnNode(int x, int y, int range) {
  int i;
  //Iterate through all the nodes
  for (i=0; i<nodes.length; i++) {
    //Does the node position plus its radius equal the x and y position of the cursor?
    if ((x<=(nodes[i].xpos + range) && x>=(nodes[i].xpos - range)) && (y<=(nodes[i].ypos +range) && y>=(nodes[i].ypos - range))) {
      //Return the clicked node
      return nodes[i];
    }
  }
  //Return a non-existant node
  Node error = new Node(-1, -1, '?');
  return error;
}

//Function to determine what node was clicked on
Node clickedOnCPUNode(int x, int y, int range) {
  int i;
  //Iterate through all the nodes
  for (i=0; i<computernodes.length; i++) {
    //Does the node position plus its radius equal the x and y position of the cursor?
    if ((x<=(computernodes[i].xpos + range) && x>=(computernodes[i].xpos - range)) && (y<=(computernodes[i].ypos +range) && y>=(computernodes[i].ypos - range))) {
      //Return the clicked node
      return computernodes[i];
    }
  }
  //Return a non-existant node
  Node error = new Node(-1, -1, '?');
  return error;
}

boolean isSamePos(int x1, int x2, int y1, int y2, int range) {
  if (x1 >= (x2 - range) && x1 <= (x2 + range) && y1 >= (y2 - range) && y1 <= (y2 + range)) {
    return true;
  } else {
    return false;
  }
}
