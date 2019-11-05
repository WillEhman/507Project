//Built-in Processing function to check if the mouse has been pressed
void mousePressed() {
  //Has the swap modes button been pressed?
  if (modeSwap.isPressed(mouseX, mouseY) && noMoreNodes == false) {
    //Swap modes
    swapModes();
  }

  //Has the optimize button been pressed?
  if (optimize.isPressed(mouseX, mouseY)) {
    startOptimizing = true;
    startTime=millis();
    modeSwap.textColor = 128; //Grey out the mode swap button
    noMoreNodes = true; //Disable drawing nodes
  }

  //Has the step button been pressed?
  if (step.isPressed(mouseX, mouseY)) {
    stepOptimize();
    modeSwap.textColor = 128; //Grey out the mode swap button
    noMoreNodes = true; //Disable drawing nodes
  }

  //Has the reset button been pressed?
  if (reset.isPressed(mouseX, mouseY)) {
    //Reset the program
    reset();
  }

  //Does the lower bound slider need to be moved?
  if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && lowerBalanceSlider.x <= 680 && lowerBalanceSlider.x >= 520 && mouseX+5 < upperBalanceSlider.x && mouseX+5 < 600) {
    //Move the slider
    lowerBalanceSlider.x = mouseX-5;
    lowerBalanceCriteria = (lowerBalanceSlider.x-520)*100/160;
  }

  //Does the upper bound slider need to be moved?
  if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && upperBalanceSlider.x <= 680 && upperBalanceSlider.x >= 520 && mouseX-5 > lowerBalanceSlider.x && mouseX+5 > 600) {
    //Move the slider
    upperBalanceSlider.x = mouseX-5;
    upperBalanceCriteria = (upperBalanceSlider.x-520)*100/160;
  }

  //Should we draw a node or edge?
  if (mouseX<500 && !noMoreNodes) { //Are we allowed to draw nodes/edges?
    if (nodeMode) {
      //Create a node centered at the cursor
      createNodes();
    }
    if (edgeMode) { //edgeMode
      //Create an edge end at the clicked node
      createEdges();
    }
  }
}

//Function to swap the mode
void swapModes() {
  if (nodeMode == true) { //Change to edge mode
    nodeMode = false;
    edgeMode = true;
    modeSwap.text = "Edge";
  } else if (edgeMode == true) { //Change to node mode
    edgeMode = false;
    nodeMode = true;
    modeSwap.text = "Node";
  }
}

//Function to create new nodes
void createNodes() {
  if (clickedOnNode(mouseX, mouseY, 50).id == '?' && nodes.length < 26 && (mouseX < (partition_x1-25) || mouseX > (partition_x1+25))) { //Check if we clicked in an occupied space
    //Create the new node
    Node newNode = new Node(mouseX, mouseY, char(nodes.length + 65));
    //Add the node to the list of nodes
    nodes = (Node[])append(nodes, newNode);
  }
}

//Function to create new edges
void createEdges() {
  //Make the clicked on node the selected node
  Node selectedNode = clickedOnNode(mouseX, mouseY, 25);
  //Does the selected node exist?
  if (selectedNode.id != '?') {
    //Is the node the first of the pair
    if (firstEdge) {
      firstNode = selectedNode;
      firstEdge = false;
    } else {
      //Is the clicked node not the same as the previous one?
      if (selectedNode.id != firstNode.id) {
        int exists = connectionExists(firstNode, selectedNode);
        //Does the connection already exist?
        if (exists != -1) {
          //Increase the weight of the connection
          connections[exists].weight++;
        } else {
          //Create a new connection and add it to the list of connections
          connections = (Connection[])append(connections, new Connection(firstNode, selectedNode));
        }
        firstEdge=true;
      }
    }
  }
}

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
