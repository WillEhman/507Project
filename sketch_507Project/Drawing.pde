//Draw the background
void drawBackground() {
  background(28, 51, 61, 1);
}

void drawGameLayout() {
  drawBackground();
  strokeWeight(10);
  stroke(212, 244, 221);
  line(width/2, 0, width/2, height);
  strokeWeight(3);
}

void drawCPUScore() {
  CPUnetCuts = countNetcuts(computernodes, cpuconnections);
  fill(212, 244, 221);
  textSize(40);
  text(CPUnetCuts, 3*width/4, 100);
}

void drawPlayerScore() {
  netCuts = countNetcuts(nodes, connections, playerPartition);
  fill(212, 244, 221);
  textSize(40);
  text(netCuts, 1*width/4, 100);
}

////Draw the sidebar
//void drawSidebar() {
//  stroke(0, 0, 0);
//  fill(128, 128, 128);
//  rect(500, 0, 200, 500);
//  netCuts = countNetcuts(nodes, connections);
//  drawNetcuts(netCuts);
//  drawCellList();
//  line(500, 300, 700, 300);
//  strokeWeight(10);
//  stroke(64);
//  line(520, 360, 680, 360);
//  textAlign(CENTER);
//  text("Balance Criteria", 600,345);
//  //text(str(lowerBalanceCriteria), lowerBalanceSlider.x+4, lowerBalanceSlider.y-2+33);
//  //text(str(upperBalanceCriteria), upperBalanceSlider.x+4, upperBalanceSlider.y-2+33);
//  strokeWeight(3);
//  textAlign(LEFT);
//}

//Draw the buttons
void drawButtons() {
  //Iterate through all the buttons and draw them
  for (int i = 0; i<buttons.length; i++) {
    if (buttons[i].draw) {
      buttons[i].drawButton();
    }
  }
}

//Draw the nodes
void drawNodes() {
  //Iterate throug all the nodes and draw them
  for (int i = 0; i < nodes.length; i++) {
    drawNode(nodes[i]);
    drawNode(computernodes[i]);
  }
}

//Draw the given node
void drawNode(Node node) {
  strokeWeight(5);
  stroke(42, 158, 92);
  fill(157, 219, 184);
  circle(node.xpos, node.ypos, 50);
  strokeWeight(3);
  textSize(14);
  fill(28, 51, 61);
  text(node.id, node.xpos, node.ypos);
}

//Draw the custom cursor
void drawCursor() {
  stroke(212, 244, 221);
  line(mouseX+5, mouseY, mouseX-5, mouseY);
  line(mouseX, mouseY-5, mouseX, mouseY+5);
}

//Draw a line between the node and the cursor
void drawEdgemaker() {
  //Check if we are in edge mode
  if (edgeMode) {
    //Check if the second node has been clicked
    if (!firstEdge) {
      stroke(42, 158, 92);
      line(firstNode.xpos, firstNode.ypos, mouseX, mouseY);
    }
  }
}

//Draw the list of nodes in each partition on the sidebar
void drawCellList() {
  //Find the nodes in partition A
  char [] a = count_partition(partition_x1, true);
  if (a.length>13) {
    a = splice(a, '\n', 13);
  }
  //Make a string of the nodes in partition A
  String a_list = new String(a);

  //Find the nodes in partition B
  char [] b = count_partition(partition_x1, false);
  if (b.length>13) {
    b = splice(b, '\n', 13);
  }
  //Make a string of the nodes in partition B
  String b_list = new String(b);

  //Display the strings
  textSize(14); 
  text("A: " + a_list, 510, 430);
  text("B: " + b_list, 510, 470);
}

//Draw the number of net cuts on the sidebar
void drawNetcuts(int cuts) {
  textSize(25);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  text("NC: " + str(cuts), 550, 330);
}

//Draw the connections between the nodes
void drawConnections() {
  //Check if any nodes exist
  if (nodes.length > 0) {
    //Iterate through all the nodes
    for (int i = 0; i < connections.length; i++) {
      //Draw the connection
      stroke(42, 158, 92);
      line(connections[i].node1.xpos, connections[i].node1.ypos, connections[i].node2.xpos, connections[i].node2.ypos);
    }
  }
}
void drawCPUConnections() {
  //Check if any nodes exist
  if (computernodes.length > 0) {
    //Iterate through all the nodes
    for (int i = 0; i < cpuconnections.length; i++) {
      //Draw the connection
      stroke(42, 158, 92);
      line(cpuconnections[i].node1.xpos, cpuconnections[i].node1.ypos, cpuconnections[i].node2.xpos, cpuconnections[i].node2.ypos);
      fill(212, 244, 221);
    }
  }
}

void showPlayerVictory(boolean player) {
  if (player) {
    Button playerWins = new Button(screenwidth/2, screenheight/2, 200, 50, "PLAYER WINS");
  } else {
    Button cpuWins = new Button(screenwidth/2, screenheight/2,  230, 50, "COMPUTER WINS");
  }
}

void showUnbalanced() {
  Button playerUnbalanced = new Button(screenwidth/2, screenheight/2+100,  210, 50, "NOT BALANCED");
}

//Draw the partition divider and labels
void drawPartition() {
  stroke(13, 113, 112);
  line(partition_x1, 0, partition_x1, height); //Guarantees that line goes off screen in
}

//Draw the partition that the player makes
void drawPlayerPartition() {
  if (!doneDrawingPartition && playerPartition.length != 0 && startedGame) {
    stroke(13, 113, 112);
    line(playerPartition[playerPartition.length - 1].xpos, playerPartition[playerPartition.length - 1].ypos, mouseX, mouseY);
  }
  for (int i = 0; i < playerPartition.length - 1; i++) {
    line(playerPartition[i].xpos, playerPartition[i].ypos, playerPartition[i+1].xpos, playerPartition[i+1].ypos);
  }
  fill(42, 158, 92);
}
