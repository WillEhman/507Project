import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_507Project extends PApplet {

//Establish the properties of the program window
public void setup() {
   //run the program at fullscreen
  frameRate(120); //runs by default at 120 fps, can be changed if there are framerate issues
  noCursor();
  logo = loadImage("Netcut.png"); //load the game logo

  //we set the global variables such that we always have access to the initial width and height of the screen
  screenwidth = width;
  screenheight = height;
  partition_x1 = 3*screenwidth/4; 
  reInitButtons(); //re-set the buttons so they fit properly on any screen size
}

//Call the functions to draw on the program window
public void draw() {
  drawNoButtons(); //hide all buttons by default
  switch (ProgramState) {
    
  case 0: //The Menu case
    //Define the buttons to use in this screen
    play.draw = true;
    rules.draw = true;

    drawBackground(); //draw the background
    image(logo, width/2-735/2, 100); //draw the game logo

    drawEscape(); //Draw a text notice that the user must press escape to quit the game from main menu
    drawButtons(); //draw the buttons on the Menu
    break; //End of Menu case
    
  case 1: //The Rules case
    //Define the buttons to use in this screen
    mainMenu.draw=true;
    
    drawBackground();//draw the background
    drawRules(); //draw the rules text block
    drawButtons(); //draw the buttons on the ruels menu
    break; //End of Rules case
    
  case 2: //The Game case
    //Define the buttons to use in this screen
    if (!startedGame) {
      start.draw = true; //draw the start button if the game hasnt started yet
    }
    bestScore.draw = true;
    reset.draw = true;
    balanceCriteria.draw = true;
    quit.draw=true;
    if (playerFailed) {
      playerUnbalanced.draw=true; //if the player failed to draw a balanced partition, let them try again, but let them know they failed
    }

    drawGameLayout(); //draw the game background
    drawTimer(); //draw a timer bar so the player knows how much time he has left

    ////calculate the number of Net Cuts
    calculateGains();
    calculateCPUGains();

    //If player is done
    if (doneDrawingPartition && playerPartition.length > 1) {
      determineVictory(); //determine who won
    }
    
    //if the computer is done and the user is not, computer wins
    if (!startOptimizing && startedGame ) {
      gameOver = true;
      showPlayerVictory(false);
    }

    //RUN CPU AI
    ////If the start button has been pressed, run the optimization algorithm
    if (startOptimizing && !gameOver) {
      optimizeNetcuts(1000);
    }


    ////Draw the various parts of the User Interface
    drawPartition();
    drawPlayerPartition();
    drawConnections();
    drawNodes();
    drawButtons();
    drawCPUScore();
    drawPlayerScore();
    break; //End of Game case
    
  case 3: //Level select
    easy.draw=true;
    medium.draw=true;
    hard.draw=true;
    mainMenu.draw = true;
    drawBackground();
    drawButtons();
    break; //End of level select
    
  }
  drawCursor(); //in all cases, draw the cursor over everything else
}

//Pallette
//https://coolors.co/1c333d-0d7170-2a9e5c-9ddbb8-d4f4dd
//$color1: rgba(28, 51, 61, 1); dark blue
//$color2: rgba(13, 113, 112, 1); lighter dark blue
//$color3: rgba(42, 158, 92, 1); dark green
//$color4: rgba(157, 219, 184, 1); light green
//$color5: rgba(212, 244, 221, 1); light aqua
//Calculate the gain for all nodes
public void calculateGains() {
  //Iterate through each node and calculate the gain
  for (int i = 0; i<nodes.length; i++) {
    nodes[i].calculateGain();
  }
}

//Calculate the gain for all nodes
public void calculateCPUGains() {
  //Iterate through each node and calculate the gain
  for (int i = 0; i<computernodes.length; i++) {
    computernodes[i].calculateCPUGain();
  }
}

//iterate through FM optimization quickly and determine what the solution is, before the player starts playing
public void findBestScore() {
  startedGame=true;
  Iteration initialsave = new Iteration(computernodes); //save the initial state
  while (startedGame) {
    optimizeNetcuts(true);
    gameTime++; //time how long it takes the computer to solve the netlist
  }
  gameTime--; //reduce by 1 so remove the final swapped state
  gameTime *= 1000; //multiply by 1000 so it can be used as a timer
  bestSave = new Iteration(computernodes); //save the solution state
  initialsave.load(); //load the initial state
  bestScore.text = str(bestNetCut); //write the best score to the screen
  startedGame=false;
}

//Step through the optimization algorithm once per second
//Runs the optimization algorithm to completion
public void optimizeNetcuts(int speed) {
  //Step through the optimization once every second
  if ((millis()-startTime) > speed) {
    stepOptimize(false);
    startTime = millis();
  }
}

public void optimizeNetcuts(boolean is_initial) {
  //Step through the optimization as fast as possible
  CPUnetCuts = countNetcuts(computernodes, cpuconnections);
  stepOptimize(is_initial);
}

//The optimization algorithm -- FM net cut optimization
//Only performs one iteration of the FM algorithm
public void stepOptimize(boolean is_initial) { 
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
public Node swapPartition(Node node) {
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
public int connectionExists(Node x, Node y) {
  for (int i = 0; i<connections.length; i++) {
    if ((connections[i].node1.id == x.id && connections[i].node2.id == y.id) || (connections[i].node2.id == x.id && connections[i].node1.id == y.id)) {
      return i;
    }
  }
  return -1;
}

//Function to count the net cuts
public int countNetcuts(Node[] nodearray, Connection[] connectionarray) {
  int cuts = 0;
  //Run algorithm if there are nodes
  if (nodearray.length > 0) {
    //Run for each nodes
    for (int i = 0; i < connectionarray.length; i++) {
      //Algorithm http://jeffreythompson.org/collision-detection/line-line.php
      //Checks to see if two lines intersect, in this case the partition divider and an edge
      Node node1 = connectionarray[i].node1;
      Node node2 = connectionarray[i].node2;

      Point p1 = new Point(PApplet.parseInt(node1.xpos), PApplet.parseInt(node1.ypos));
      Point p2 = new Point(PApplet.parseInt(node2.xpos), PApplet.parseInt(node2.ypos));
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
public int countNetcuts(Node[] nodearray, Connection[] connectionarray, Point[] pointarray) {
  int cuts = 0;
  //Run algorithm if there are nodes
  if (nodearray.length > 0) {
    //Run for each nodes
    for (int i = 0; i < connectionarray.length; i++) {
      for (int j = 1; j < pointarray.length; j++) {

        Node node1 = connectionarray[i].node1;
        Node node2 = connectionarray[i].node2;

        Point p1 = new Point(PApplet.parseInt(node1.xpos), PApplet.parseInt(node1.ypos));
        Point p2 = new Point(PApplet.parseInt(node2.xpos), PApplet.parseInt(node2.ypos));
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
//Checks to see if two lines intersect
public boolean checkIntersection(Point a, Point b, Point c, Point d) {
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
public int findNode(char c) {
  for (int i = 0; i<nodes.length; i++) {
    if (nodes[i].id == c) {
      return i;
    }
  }
  return -1;
}

//Count the number of nodes in a partition
public char [] count_partition(int x, boolean less_than) {
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

//Simple function for finding node with the highest gain
public int findHighestGain() {
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

//create nodecount nodes at random x and y positions, checking for conflict with UI elements or other nodes as it goes for both player and computer
public void createRandomNodes(int nodecount) {
  for (int i=0; i< nodecount; ) {
    float randomX = random(0, width/2);
    float randomY = random(0, height);
    if (clickedOnNode((int)randomX, (int)randomY, 100).id == '?' && randomX < ((width/2)-100) && randomX > 50 && (randomX < ((width/4)-50) || randomX > ((width/4)+50)) && randomY < (height-50) && randomY > 50) { //Check if we clicked in an occupied space
      Node newNode = new Node(randomX, randomY, PApplet.parseChar(i+65));
      //Add the node to the list of nodes
      nodes = (Node[])append(nodes, newNode);
      Node newCPUNode = new Node(randomX+(width/2), randomY, PApplet.parseChar(i+97));
      computernodes = (Node[])append(computernodes, newCPUNode);
      i++;
    }
  }
}

//create random edges between the list of nodes, for both user and computer, such that they are identical
public void createRandomEdges(int edgecount) {
  for (int i=0; i< edgecount; i++) {
    int randomi = (int)random(0, nodes.length);
    createEdges((int)nodes[randomi].xpos, (int)nodes[randomi].ypos);
  }
}
//Custom class to describe all the button properties
class Button { 
  int x, y; //The x and y position of the button
  int w, h; //The width and height of the button
  String text; //The text in the button
  int textColor = 0; //The colour of the button
  boolean draw = true;
  boolean hoverable = true;

  //Constructor for creating a button of default height and width, with custom text, x, and y position
  Button (int myX, int myY, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = 120;
    h = 50;
    buttons = (Button[])append(buttons, this); //Add the new button to the list of buttons
  }

  //Constructor for creating a button with custom height, width, text, x, and y position
  Button (int myX, int myY, int myW, int myH, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = myW;
    h = myH;
    buttons = (Button[])append(buttons, this); //Add the new button to the list of buttons
  }

  //Function to draw the button
  public void drawButton() {
    stroke(212, 244, 221);
    strokeWeight(1);
    buttonHovered();
    rect(x-(w/2), y, w, h);
    fill(212, 244, 221);
    textAlign(CENTER);
    textSize(26);
    text(text, x+2, y+h-12);
  }

  //Funcition to check if the button has been pressed
  public boolean isPressed(int mousex, int mousey) {
    if ((mousex >= x-(w/2) && mousex < x+(w/2)) && (mousey >= y && mousey < y+h)) {
      //The button has been pressed
      return true;
    }
    //The button has not been pressed
    return false;
  }
  
  //if the mouse is over the button, draw it with a slightly lighter colour to indicate it is being hovered
  public void buttonHovered() {
    if ((mouseX >= x-(w/2) && mouseX < x+(w/2)) && (mouseY >= y && mouseY < y+h) && hoverable) {
      fill(58, 81, 91);
    } else {
      fill(28, 51, 61);
    }
  }
}

//re-initialize the buttons to their initial state
public void reInitButtons(){
  buttons = new Button[0]; //The list of buttons
  start = new Button(screenwidth/2, screenheight/2, "Start"); //The Start button
  bestScore = new Button(screenwidth/2, 100, str(bestNetCut));
  reset = new Button(screenwidth/2, screenheight/2+200, "Reset");  //The reset button
  play = new Button(screenwidth/2, screenheight/2-50, "Play");
  rules = new Button(screenwidth/2, screenheight/2+50, "Rules");
  mainMenu = new Button(screenwidth/2, screenheight/2+300, 200, 50, "Main Menu");
  balanceCriteria = new Button(screenwidth/2, screenheight-80, 190, 50, partitioning); 
  quit = new Button(screenwidth/2, screenheight-140, "Quit");
  easy = new Button(screenwidth/2, screenheight/2-100, "Easy");
  medium = new Button(screenwidth/2, screenheight/2, "Medium");
  hard = new Button(screenwidth/2, screenheight/2+100, "Hard");
}
//Custom class to describe a connection between nodes
class Connection { 
  Node node1, node2; //The 2 nodes being connected
  boolean cut; //If the connection is cut
  int weight; //The weight of the connection
  
  //Constructor to create a new connection.
  Connection (Node x, Node y) {  
    node1 = x; 
    node2 = y;
    cut = false;
    weight = 1;
  }
}
//Draw the background
public void drawBackground() {
  background(28, 51, 61, 1);
}

//draw the escape indicator
public void drawEscape() {
  fill(212, 244, 221);
  textSize(20);
  text("ESC to quit", 60, 20);
}

//draw the base game layout for the UI
public void drawGameLayout() {
  drawBackground();
  strokeWeight(10);
  stroke(212, 244, 221);
  line(width/2, 0, width/2, height);
  strokeWeight(3);
}

//draw a bar that shrinks to represent the time left before the computer finishes
public void drawTimer() {
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
public void drawCPUScore() {
  CPUnetCuts = countNetcuts(computernodes, cpuconnections);
  fill(212, 244, 221);
  textSize(40);
  text(CPUnetCuts, 3*width/4, 100);
}

//draw the palyers current netcuts
public void drawPlayerScore() {
  netCuts = countNetcuts(nodes, connections, playerPartition);
  fill(212, 244, 221);
  textSize(40);
  text(netCuts, 1*width/4, 100);
}

//Draw the buttons
public void drawButtons() {
  //Iterate through all the buttons and draw them
  for (int i = 0; i<buttons.length; i++) {
    if (buttons[i].draw) {
      buttons[i].drawButton();
    }
  }
}

//Make no buttons be drawn
public void drawNoButtons() {
  //Make these un-hoverable
  balanceCriteria.hoverable = false;
  bestScore.hoverable = false;
  //Iterate through all the buttons and draw them
  for (int i = 0; i<buttons.length; i++) {
    buttons[i].draw = false;
  }
}

//Draw the nodes
public void drawNodes() {
  //Iterate throug all the nodes and draw them
  for (int i = 0; i < nodes.length; i++) {
    drawNode(nodes[i]);
    drawNode(computernodes[i]);
  }
}

//Draw the given node
public void drawNode(Node node) {
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
public void drawCursor() {
  stroke(212, 244, 221);
  line(mouseX+5, mouseY, mouseX-5, mouseY);
  line(mouseX, mouseY-5, mouseX, mouseY+5);
}

//Draw the list of nodes in each partition on the sidebar
public void drawCellList() {
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
public void drawNetcuts(int cuts) {
  textSize(25);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  text("NC: " + str(cuts), 550, 330);
}

//Draw the connections between the nodes for computer and player
public void drawConnections() {
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
public void showPlayerVictory(boolean player) {
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
public void showUnbalanced() {
  playerFailed=true;
  playerPartition = new Point[0];
  doneDrawingPartition = false;
  startedGame=true;
}

//Draw the partition divider and labels
public void drawPartition() {
  stroke(13, 113, 112);
  line(partition_x1, 0, partition_x1, height); //Guarantees that line goes off screen in
}

//Draw the partition that the player makes
public void drawPlayerPartition() {
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
public void drawRules() {
  String rules[] = loadStrings("Rules.txt");
  String rulesText = "";

  for (int i = 0; i < rules.length; i++) {
    rulesText = rulesText + rules[i] + "\n";
  }
  textSize(width/64);
  text(rulesText, width/2, 100);
}
//start the game and initialize the status tracking variables
public void startGame(){
 startOptimizing = true;
 startedGame = true;
 timerStart = millis();
}

//intialize all the variables and setup for a new game
public void initGame(){
  reset();
  createRandomNodes(nodeCount);
  createRandomEdges(edgeCount);
  findBestScore();
}

//determine whether the player or the computer can claim victory
public void determineVictory(){
  startedGame = false;
    netCuts = countNetcuts(nodes, connections, playerPartition);
    Iteration currentIteration = new Iteration(nodes);

    if (netCuts <= bestNetCut) {
      if (currentIteration.checkBalanced()) {
        showPlayerVictory(true);
        startOptimizing = false;
      } else {
        showUnbalanced();
      }
    } else {
      showPlayerVictory(false);
      startOptimizing = false;
    }    
    
}
//All the global variables used in the program
int nodeCount; //a count of the number of nodes to generate, changes by difficulty
int edgeCount; //a count of the number of edges to generate, changes by difficulty
int screenwidth; //a value that tracks the screenwidth
int screenheight; //a value that tracks the screen height
boolean nodeMode = true; //Are we in node mode?
boolean edgeMode = false; //Are we in edge mode?
boolean firstEdge = true; //Is this the first end of the edge?
boolean firstCPUEdge = true; //Is this the first end of the edge?
Node firstNode;  //The first node in used in making a connection
Node firstCPUNode;  //The first node in used in making a connection
Node[] nodes = new Node[0]; //The list of nodes
Node[] computernodes = new Node[0]; //The list of nodes
int partition_x1 = 3*screenwidth/4; //The partition boundary
Connection[] connections = new Connection[0]; //The list of connections
Connection[] cpuconnections = new Connection[0]; //The list of connections
Iteration save[] = new Iteration[0]; //The list of steps in the optimization process
int netCuts; //The number of net cuts
int CPUnetCuts; //The number of CPU net cuts
boolean startOptimizing = false; //Should the program run the optimization fully?
int startTime; //The time at the start of a function
int lowerBalanceCriteria = 30; //The lower bound of the balance criteria
int upperBalanceCriteria = 100-lowerBalanceCriteria; //The upper bound of the balance criteria
boolean noMoreNodes = false; //Allow more nodes/edges to be drawn?
Point playerPartition[] = new Point[0]; //Array containing the points that make up the player partition
boolean doneDrawingPartition = false; //Are we done drawing the partition
int lastX = 0; //The last X position clicked
int lastY = 0; //The last Y position clicked
boolean startedGame = false; //status of the game running
int bestNetCut= 99999; //the best netcut achieved by the computer
int ProgramState = 0; //0 is menu, 1 is rules, 2 is game
boolean gameOver = false; //has the game ended?
boolean playerFailed = false; //did the player fail to achieve balance
int gameTime = 0; //tracker for how long the computer will take to solve the netlist
int timerStart = 0; //timer for when the program initially starts
PImage logo; //the game's logo

//Buttons
Button [] buttons = new Button[0]; //The list of buttons

Button start = new Button(screenwidth/2, screenheight/2, "Start"); //The Start button
Button bestScore = new Button(screenwidth/2, 100, str(bestNetCut));//The Bestscore indicator
Button reset = new Button(screenwidth/2, screenheight/2+200, "Reset");  //The reset button
Button play = new Button(screenwidth/2, screenheight/2-50, "Play"); //The Play button
Button rules = new Button(screenwidth/2, screenheight/2+50, "Rules"); //The Rules button
Button mainMenu = new Button(screenwidth/2, screenheight/2+300, 200, 50, "Main Menu"); //The Main menu button
String partitioning = "Balance: " + str(ceil((lowerBalanceCriteria/100.0f)*nodeCount)) + "/" + str(nodeCount); //a string to store the calculations of the balance criteria
Button balanceCriteria = new Button(screenwidth/2, screenheight-80, 190, 50, partitioning);  //The Balance Indicator
Button quit = new Button(screenwidth/2, screenheight-140, "Quit"); //The Quit button
Button easy = new Button(screenwidth/2, screenheight/2-100, "Easy"); //The easy button
Button medium = new Button(screenwidth/2, screenheight/2, "Medium"); //The medium button
Button hard = new Button(screenwidth/2, screenheight/2+100, "Hard"); //The hard button
Button playerUnbalanced = new Button(screenwidth/2, screenheight/2+100,  210, 50, "NOT BALANCED");  //The Unbalanced indicator
Iteration bestSave; //The best saved iteration, used to display the solution

//Function to reset the program to the initial conditions
public void reset() {
  nodes = new Node[0];
  connections = new Connection[0];
  computernodes = new Node[0];
  cpuconnections = new Connection[0];
  save = new Iteration[0];
  firstNode = new Node();
  startOptimizing = false;
  noMoreNodes = false;
  //nodeMode = true;
  //edgeMode = false;
  firstEdge = true;
  firstCPUEdge = true;
  playerPartition = new Point[0];
  doneDrawingPartition = false;
  lastX = 0;
  lastY = 0;
  bestNetCut= 99999;
  reInitButtons();
  partitioning = "Balance: " + str(ceil((lowerBalanceCriteria/100.0f)*nodeCount)) + "/" + str(nodeCount);
  playerUnbalanced = new Button(screenwidth/2, screenheight/2+100,  210, 50, "NOT BALANCED");
  startedGame = false;
  gameOver = false;
  playerFailed = false;
  gameTime = 0;
  timerStart = 0;
}
//Built-in Processing function to check if the mouse has been pressed
public void mousePressed() {
  switch(ProgramState) {
  case 0: //Menu case
    //Has the play button been pressed?
    if (play.isPressed(mouseX, mouseY)) {
      ProgramState = 3; //go to game
    } else if (rules.isPressed(mouseX, mouseY)) {//Has the rules button been pressed?
      ProgramState = 1; //go to rules
    }
    break; //End of Menu case
  case 1: //Rules case
    //Has the main menu button been pressed?
    if (mainMenu.isPressed(mouseX, mouseY)) {
      ProgramState = 0; //go to menu
    }
    break; //End of Rules case
  case 2: //Game case

    //Has the step button been pressed?
    if (start.isPressed(mouseX, mouseY)) {
      startGame(); //start game
    }

    //Has the reset button been pressed?
    if (reset.isPressed(mouseX, mouseY)) {
      //Reset the program
      reset();
      initGame();
    }
    //Has the quit button been pressed?
    if (quit.isPressed(mouseX, mouseY)) {
      reset();
      ProgramState = 0;
    }

    //Did the mouse click a free space on the Player side?
    if (startedGame) {
      if (mouseX > 0 && mouseX < width/2 && clickedOnNode(mouseX, mouseY, 25).id == '?' && !start.isPressed(mouseX, mouseY)) {
        Point currentPoint = new Point(mouseX, mouseY);
        boolean selfIntersect = false;
        //check if the partition will intersect with itself, causing an issue
        for (int i = 1; i < playerPartition.length-1; i++) {
          if (checkIntersection(playerPartition[i-1], playerPartition[i], playerPartition[playerPartition.length-1], currentPoint)) {
            selfIntersect = true;
            break;
          }
        }
        //if the position is legal and the game hasnt ended
        if (!selfIntersect && !gameOver) {
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
          lastX = mouseX;
          lastY = mouseY;
        }
      }
    } else {
      //if the player clicks once, store the values in case of a double click
      if (mouseX > 0 && mouseX < width/2 && clickedOnNode(mouseX, mouseY, 25).id == '?' && !start.isPressed(mouseX, mouseY)) {
        if (isSamePos(lastX, mouseX, lastY, mouseY, 10) && !doneDrawingPartition) {
          doneDrawingPartition = true;
        }
      }
      lastX = mouseX;
      lastY = mouseY;
    }
    break; //End of Game case
  case 3:
    //difficulty select screen
    if (easy.isPressed(mouseX, mouseY)) {//if player selects easy, create a game of that difficulty
      ProgramState = 2;
      nodeCount = 5;
      edgeCount = 30;
      initGame();
    }
    if (medium.isPressed(mouseX, mouseY)) {//if player selects medium, create a game of that difficulty
      ProgramState = 2;
      nodeCount = 8;
      edgeCount = 50;
      initGame();
    }
    if (hard.isPressed(mouseX, mouseY)) {//if player selects hard, create a game of that difficulty
      ProgramState = 2;
      nodeCount = 10;
      edgeCount = 75;
      initGame();
    }

    if (mainMenu.isPressed(mouseX, mouseY)) {//if player selects menu, return there
      ProgramState = 0;
    }
  }
}

//Function to swap the mode
public void swapModes() {
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
public void createNodes() {
  if (clickedOnNode(mouseX, mouseY, 50).id == '?' && nodes.length < 26 && (mouseX < (partition_x1-25) || mouseX > (partition_x1+25))) { //Check if we clicked in an occupied space
    //Create the new node
    Node newNode = new Node(mouseX, mouseY, PApplet.parseChar(nodes.length + 65));
    //Add the node to the list of nodes
    nodes = (Node[])append(nodes, newNode);
    Node newCPUNode = new Node(mouseX+width/2, mouseY, PApplet.parseChar(nodes.length + 65));
    //Add the node to the list of nodes
    computernodes = (Node[])append(computernodes, newCPUNode);
  }
}

//Function to create new edges
public void createEdges(int x, int y) {
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

//Function to determine what node was clicked on
public Node clickedOnNode(int x, int y, int range) {
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
public Node clickedOnCPUNode(int x, int y, int range) {
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

//if node occupies same position within a range
public boolean isSamePos(int x1, int x2, int y1, int y2, int range) {
  if (x1 >= (x2 - range) && x1 <= (x2 + range) && y1 >= (y2 - range) && y1 <= (y2 + range)) {
    return true;
  } else {
    return false;
  }
}
//Custom class to save the iterations of the optimization process
class Iteration {
  Node nodeList[]; //The node list at the current iteration
  int cuts; //The number of cuts in the iteration
  boolean isBalanced; //Does the iteration meet the balance criteria?

  //Custom constructor to create a new iteration
  Iteration(Node[] nodearray) {
    nodeList = new Node[0]; //Initialize the iteration's node list
    //Iterate through all the nodes
    for (int i = 0; i < nodearray.length; i++) {
      //Add the node to the iteration's node list
      nodeList = (Node[])append(nodeList, new Node());
      nodeList[i].makeCopy(nodearray[i]);
    }
    //Get the number of net cuts in this iteration
    cuts = CPUnetCuts;
    
    //Calculate if the iteration meets the balance criteria    
    isBalanced = checkBalanced();
  }
  
  public boolean checkBalanced(){
    //Calculate if the iteration meets the balance criteria
    int temp = 0;
    //Iterate through all nodes
    for (int i = 0; i < nodeList.length; i++) {
      //Is the node in partition A?
      if (nodeList[i].partition == 'A') {
        //Increase the count of nodes in partition A
        temp++;
      }
    }
    //Does the percentage of nodes in partition A meet the balance criteria
    if (((PApplet.parseFloat(temp)/nodeList.length)*100) > lowerBalanceCriteria && ((PApplet.parseFloat(temp)/nodeList.length)*100) <= upperBalanceCriteria) {
      return true;
    }
    return false;
  }

  //Function to make this iteration the current display
  public void load() {
    //Iterate through all the nodes
    for (int i = 0; i < computernodes.length; i++) {
      //Copy the nodes from this iteration into the display
      computernodes[i].makeCopy(nodeList[i]);
    }
  }
}
//Custom class to describe nodes
class Node { 
  float xpos, ypos; //The x and y position of the node
  char id; //The identifier for the node
  boolean isFixed; //Has this node been fixed in place by the optimization process
  int gain; //The gain of the node
  char partition; //Which partition the node is in

  //Custom constructor to create a node
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
    gain = 0;
    partition = calculatePartition();
  }

  //Custom constructor to create an unlabelled node
  Node (float x, float y) {  
    xpos = x; 
    ypos = y;
    id = PApplet.parseChar(nodes.length+65);
    isFixed = false;
    gain = 0;
    partition = calculatePartition();
  }

  //Custom constructor to create a blank node
  Node () {
    xpos = 0; 
    ypos = 0;
    id = '?';
    isFixed = false;
    gain = 0;
    partition = 'c';
  }

  //Function to calculate the gain of the node
  public void calculateGain() {
    int cut = 0; //The number of cut connections
    int uncut = 0; //The number of uncut connections
    //Iterate through all the connections 
    for (int i = 0; i<connections.length; i++) {
      //Is the connection cut?
      if (connections[i].node1.id == this.id || connections[i].node2.id == this.id ) {
        if (connections[i].cut == true) {
          cut+=1;
        } else {
          uncut+=connections[i].weight;
        }
      }
    }
    //Calculate the gain
    gain = cut - uncut;
    partition = calculatePartition(playerPartition);
  }

  //Function to calculate the gain of the node
  public void calculateCPUGain() {
    int cut = 0; //The number of cut connections
    int uncut = 0; //The number of uncut connections
    //Iterate through all the connections 
    for (int i = 0; i<cpuconnections.length; i++) {
      //Is the connection cut?
      if (cpuconnections[i].node1.id == this.id || cpuconnections[i].node2.id == this.id ) {
        if (cpuconnections[i].cut == true) {
          cut+=1;
        } else {
          uncut+=cpuconnections[i].weight;
        }
      }
    }
    //Calculate the gain
    gain = cut - uncut;
    partition = calculatePartition();
  }

  //Function to determine which partition the node is in
  public char calculatePartition() {
    //Is the node in partition B?
    if (xpos > partition_x1) {
      //Return partition B
      return 'B';
    }
    //Return partition A
    return 'A';
  }
  //Function to determine which partition the node is in
  public char calculatePartition(Point [] pointarray) {
    //Is the node in partition B?

    //extend point to infinity to the right
    Point p1 = new Point(xpos, ypos);
    Point p2 = new Point(width, ypos);

    //run for all of the user partition
    if (pointarray.length > 1) {
      boolean intersection = false;
      int count = 0;
      for (int i = 1; i < pointarray.length; i++) {
        Point p3 = new Point(pointarray[i-1].xpos, pointarray[i-1].ypos);
        Point p4 = new Point(pointarray[i].xpos, pointarray[i].ypos);
        
        if (checkIntersection(p1, p2, p3, p4)) {
          count++;
        }
      }
      if (count%2 == 1){ //If there is an odd number of lines to the right of the node
        return 'A';
      }
    }
    return 'B';
  }

  //Function to make a copy of the node
  public void makeCopy(Node copy) {
    this.xpos = copy.xpos;
    this.ypos = copy.ypos;
    this.id = copy.id;
    this.isFixed = copy.isFixed;
    this.gain = copy.gain;
    this.partition = copy.partition;
  }
}
//custom class to define points
class Point {
  float xpos; //x coordinate of the point
  float ypos; //y coordinate of the point

  //custom constructor for creating a Point
  Point (float x, float y) {
    xpos = x;
    ypos = y;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "sketch_507Project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
