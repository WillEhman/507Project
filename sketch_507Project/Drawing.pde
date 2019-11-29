//Draw the background
void drawBackground() {
  background(28, 51, 61, 1);
}

//draw the escape indicator
void drawEscape() {
  fill(212, 244, 221);
  textSize(20);
  text("ESC to quit", 60, 20);
}

//draw the base game layout for the UI
void drawGameLayout() {
  drawBackground();
  strokeWeight(10);
  stroke(212, 244, 221);
  line(width/2, 0, width/2, height);
  strokeWeight(3);
}

//draw a bar that shrinks to represent the time left before the computer finishes
void drawTimer() {
  strokeWeight(10);
  stroke(42, 158, 92);
  float timerTime = millis()-timerStart;
  if (timerTime < gameTime && startedGame) {
    line(width/2, height, width/2, height*(timerTime/gameTime));
    gameTime--;
  }
  if (!startedGame) {
    line(width/2, height, width/2, 0);
  }
  strokeWeight(3);
}

//draw the CPUs current netcuts
void drawCPUScore() {
  CPUnetCuts = countNetcuts(computernodes, cpuconnections);
  fill(212, 244, 221);
  textSize(40);
  text(CPUnetCuts, 3*width/4, 100);
}

//draw the palyers current netcuts
void drawPlayerScore() {
  netCuts = countNetcuts(nodes, connections, playerPartition);
  fill(212, 244, 221);
  textSize(40);
  text(netCuts, 1*width/4, 100);
}

//Draw the buttons
void drawButtons() {
  //Iterate through all the buttons and draw them
  for (int i = 0; i<buttons.length; i++) {
    if (buttons[i].draw) {
      buttons[i].drawButton();
    }
  }
}

//Make no buttons be drawn
void drawNoButtons() {
  //Make these un-hoverable
  balanceCriteria.hoverable = false;
  bestScore.hoverable = false;
  //Iterate through all the buttons and draw them
  for (int i = 0; i<buttons.length; i++) {
    buttons[i].draw = false;
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
  stroke(212, 244, 221);
  fill(212, 244, 221);
  //circle(node.xpos, node.ypos, 50);
  quad(node.xpos-25, node.ypos, node.xpos, node.ypos+15, node.xpos+25, node.ypos, node.xpos, node.ypos-15);
  quad(node.xpos-15, node.ypos, node.xpos, node.ypos+25, node.xpos+15, node.ypos, node.xpos, node.ypos-25);
  strokeWeight(3);
  textSize(14);
  fill(212, 244, 221);
  text(node.id, node.xpos, node.ypos);
}

//Draw the custom cursor
void drawCursor() {
  stroke(212, 244, 221);
  line(mouseX+5, mouseY, mouseX-5, mouseY);
  line(mouseX, mouseY-5, mouseX, mouseY+5);
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

//Draw the connections between the nodes for computer and player
void drawConnections() {
  //Check if any nodes exist
  if (nodes.length > 0) {
    //Iterate through all the nodes
    for (int i = 0; i < connections.length; i++) {
      //Draw the connection
      stroke(190, 220, 240);
      line(connections[i].node1.xpos, connections[i].node1.ypos, connections[i].node2.xpos, connections[i].node2.ypos);
      line(cpuconnections[i].node1.xpos, cpuconnections[i].node1.ypos, cpuconnections[i].node2.xpos, cpuconnections[i].node2.ypos);
    }
  }
}

//show a button to represent who has won
void showPlayerVictory(boolean player) {
  if (player) {
    Button playerWins = new Button(screenwidth/2, screenheight/2, 200, 50, "PLAYER WINS");
    playerWins.hoverable = false;
    playerFailed=false;
  } else {
    Button cpuWins = new Button(screenwidth/2, screenheight/2, 230, 50, "COMPUTER WINS");
    cpuWins.hoverable = false;
    bestSave.load();
    playerFailed=false;
  }
}

//show an indicator that the current netcut is unbalanced, and let the player try again
void showUnbalanced() {
  playerFailed=true;
  playerPartition = new Point[0];
  doneDrawingPartition = false;
  startedGame=true;
}

//Draw the partition divider and labels
void drawPartition() {
  stroke(13, 113, 112);
  line(partition_x1, 0, partition_x1, height); //Guarantees that line goes off screen in
}

//Draw the partition that the player makes
void drawPlayerPartition() {
  if (!doneDrawingPartition && playerPartition.length != 0 && startedGame && !gameOver) {
    stroke(13, 113, 112);
    line(playerPartition[playerPartition.length - 1].xpos, playerPartition[playerPartition.length - 1].ypos, mouseX, mouseY);
  }
  for (int i = 0; i < playerPartition.length - 1; i++) {
    line(playerPartition[i].xpos, playerPartition[i].ypos, playerPartition[i+1].xpos, playerPartition[i+1].ypos);
  }
  fill(42, 158, 92);
}

//draw a text string to show the instructions
void drawRules() {
  String rules[] = loadStrings("Rules.txt");
  String rulesText = "";

  for (int i = 0; i < rules.length; i++) {
    rulesText = rulesText + rules[i] + "\n";
  }
  textSize(width/64);
  text(rulesText, width/2, 100);
}
