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

public void setup() {
  
  frameRate(60);
  noCursor();
}

public void draw() {
  calculateGains();
  if (startOptimizing) {
    optimizeNetcuts();
  }
  drawBackground();
  drawPartition();
  drawEdgemaker();
  drawConnections();
  drawNodes();
  drawSidebar();
  drawButtons();
  drawCursor();
}

//NOTES:
//Should probably disable nodes/edges button after the optimization button is pressed -- Done
//Add a reset button that clears the work area -- Done
public void calculateGains() {
  for (int i = 0; i<nodes.length; i++) {
    nodes[i].calculateGain();
  }
}

public void optimizeNetcuts() {
  if ((millis()-startTime) > 1000) {
    stepOptimize();
    startTime = millis();
  }
}

public void stepOptimize() { 
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
      if (save[i].cuts < temp && save[i].isBalanced) { //If it is better and balanced
        temp = save[i].cuts;
        bestIter = i;
      }
    }
    save[bestIter].load();
    startOptimizing = false;
  }
}

public Node swapPartition(Node node) {
  int low, high;
  if (node.partition == 'A') {
    low = 275;
    high = 475;
  } else {
    low = 25;
    high = 225;
  }
  boolean not_found_spot = true;
  int rand_xpos = 0;
  int rand_ypos = 0;
  while (not_found_spot) {
    rand_xpos = (int)random(low, high);
    rand_ypos = (int)random(25, 475);
    not_found_spot = false;
    if (clickedOnNode(rand_xpos, rand_ypos, 50).id != '?') {
      not_found_spot = true;
    }
  }
  //TODO Fix it so it wont break if it can't find a spot
  node.xpos = rand_xpos;
  node.ypos = rand_ypos;
  return node;
}

public int connectionExists(Node x, Node y) {
  for (int i = 0; i<connections.length; i++) {
    if ((connections[i].node1.id == x.id && connections[i].node2.id == y.id) || (connections[i].node2.id == x.id && connections[i].node1.id == y.id)) {
      return i;
    }
  }
  return -1;
}

public int countNetcuts() {
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

public int findNode(char c) {
  for (int i = 0; i<nodes.length; i++) {
    if (nodes[i].id == c) {
      return i;
    }
  }
  return -1;
}

public char [] count_partition(int x, boolean less_than) {
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

public int findHighestGain() {
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
class Button { 
  int x, y;
  int w, h;
  String text;
  int textColor = 0;
  Button (int myX, int myY, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = 120;
    h = 50;
    buttons = (Button[])append(buttons, this);
  }
  Button (int myX, int myY, int myW, int myH, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = myW;
    h = myH;
    buttons = (Button[])append(buttons, this);
  }
  public void drawButton() {
    stroke(0, 0, 0);
    fill(255);
    rect(x, y, w, h);
    fill(textColor);
    textSize(20);
    text(text, x+2, y+h-12);
  }
  public boolean isPressed(int mousex, int mousey) {
    if ((mousex >= x && mousex < x+w) && (mousey >= y && mousey < y+h)) {
      return true;
    }
    return false;
  }
}
class Connection { 
  Node node1, node2; 
  boolean cut;
  int weight;
  Connection (Node x, Node y) {  
    node1 = x; 
    node2 = y;
    cut = false;
    weight = 1;
  }
}
public void drawBackground() {
  background(200);
}

public void drawSidebar() {
  stroke(0, 0, 0);
  fill(128, 128, 128);
  rect(500, 0, 200, 500);
  netCuts = countNetcuts();
  drawNetcuts(netCuts);
  drawCellList();
  line(500, 300, 700, 300);
  strokeWeight(10);
  stroke(64);
  line(520, 360, 680, 360);
  textAlign(CENTER);
  text("Balance Criteria", 600,345);
  text(str(lowerBalanceCriteria), lowerBalanceSlider.x+4, lowerBalanceSlider.y-2+33);
  text(str(upperBalanceCriteria), upperBalanceSlider.x+4, upperBalanceSlider.y-2+33);
  strokeWeight(3);
  textAlign(LEFT);
}

public void drawButtons() {
  for (int i = 0; i<buttons.length; i++) {
    buttons[i].drawButton();
  }
}

public void drawNodes() {
  for (int i = 0; i < nodes.length; i++) {
    drawNode(nodes[i]);
  }
}

public void drawNode(Node node) {
  stroke(0, 0, 0);
  fill(255, 255, 255);
  circle(node.xpos, node.ypos, 50);
  textSize(25);
  fill(0, 0, 0);
  text(node.id, node.xpos-9, node.ypos+8);
  textSize(12);
  text(node.gain, node.xpos-6, node.ypos+18);
}

public void drawCursor() {
  stroke(0, 0, 0);
  line(mouseX+5, mouseY, mouseX-5, mouseY);
  line(mouseX, mouseY-5, mouseX, mouseY+5);
}

public void drawEdgemaker() {
  if (edgeMode) {
    if (!firstEdge) {
      stroke(255, 0, 0);
      line(firstNode.xpos, firstNode.ypos, mouseX, mouseY);
    }
  }
}

public void drawCellList() {
  char [] a = count_partition(partition_x1, true);
  if (a.length>13) {
    a = splice(a, '\n', 13);
  }
  String a_list = new String(a);

  char [] b = count_partition(partition_x1, false);
  if (b.length>13) {
    b = splice(b, '\n', 13);
  }
  String b_list = new String(b);
  textSize(14); 
  text("A: " + a_list, 510, 430);
  text("B: " + b_list, 510, 470);
}

public void drawNetcuts(int cuts) {
  textSize(25);
  stroke(0, 0, 0);
  fill(0, 0, 0);
  text("NC: " + str(cuts), 550, 330);
}

public void drawConnections() {
  if (nodes.length > 0) {
    for (int i = 0; i < connections.length; i++) {
      stroke(0, 0, 0);
      line(connections[i].node1.xpos, connections[i].node1.ypos, connections[i].node2.xpos, connections[i].node2.ypos);
      textSize(16);
      fill(0, 0, 0);
      text(connections[i].weight, ((connections[i].node2.xpos-connections[i].node1.xpos)/2)+connections[i].node1.xpos, ((connections[i].node2.ypos-connections[i].node1.ypos)/2)+connections[i].node1.ypos-3);
    }
  }
}

public void drawPartition() {
  stroke(255, 0, 0);
  line(partition_x1, 0, partition_x1, 500); //Guarantees that line goes off screen in
  textSize(150);
  fill(128, 128, 128);
  text("A", 75, 300);  //Labels to show the two partitions
  text("B", 325, 300);
}
//Global Variables
boolean nodeMode = true;
boolean edgeMode = false;
boolean firstEdge = true;
Node firstNode;
Node[] nodes = new Node[0];
int partition_x1 = 250; 
Connection[] connections = new Connection[0];
Iteration save[] = new Iteration[0]; //Saves what nodes are in partition A, partition B can then be assumed
int netCuts;
boolean startOptimizing = false;
int startTime;
int optimizationProgress=0;
int lowerBalanceCriteria = 20;
int upperBalanceCriteria = 80;
boolean noMoreNodes = false;

//Buttons
Button [] buttons = new Button[0];

Button modeSwap = new Button(550, 30, "Node");  
Button optimize = new Button(550, 100, "Optimize");
Button step = new Button(550, 170, "Step");
Button reset = new Button(550, 240, "Reset");  
Button lowerBalanceSlider = new Button(550, 350, 10, 18, ""); 
Button upperBalanceSlider = new Button(650, 350, 10, 18, ""); 

public void reset() {
  nodes = new Node[0];
  connections = new Connection[0];
  save = new Iteration[0];
  firstNode = new Node();
  startOptimizing = false;
  lowerBalanceCriteria = 20;
  upperBalanceCriteria = 80;
  noMoreNodes = false;
  modeSwap.textColor=0;
  lowerBalanceSlider.x = 550;
  upperBalanceSlider.x = 640;
  nodeMode = true;
  edgeMode = false;
  firstEdge = true;
}
public void mousePressed() {
  if (modeSwap.isPressed(mouseX, mouseY) && noMoreNodes == false) {
    swapModes();
  }
  if (optimize.isPressed(mouseX, mouseY)) {
    startOptimizing = true;
    startTime=millis();
    modeSwap.textColor = 128;
    noMoreNodes = true;
  }
  if (step.isPressed(mouseX, mouseY)) {
    stepOptimize();
    modeSwap.textColor = 128;
    noMoreNodes = true;
  }
  if (reset.isPressed(mouseX, mouseY)) {
    reset();
  }
  if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && lowerBalanceSlider.x <= 680 && lowerBalanceSlider.x >= 520 && mouseX+5 < upperBalanceSlider.x && mouseX+5 < 600) {
    lowerBalanceSlider.x = mouseX-5;
    lowerBalanceCriteria = (lowerBalanceSlider.x-520)*100/160;
  }
  if (mouseY <= 365 && mouseY >= 355 && mouseX <= 675 && mouseX >= 525 && upperBalanceSlider.x <= 680 && upperBalanceSlider.x >= 520 && mouseX-5 > lowerBalanceSlider.x && mouseX+5 > 600) {
    upperBalanceSlider.x = mouseX-5;
    upperBalanceCriteria = (upperBalanceSlider.x-520)*100/160;
  }
  if (mouseX<500 && !noMoreNodes) {
    if (nodeMode) {
      createNodes();
    }
    if (edgeMode) { //edgeMode
      createEdges();
    }
  }
}

public void swapModes() {
  if (nodeMode == true) {
    nodeMode = false;
    edgeMode = true;
    modeSwap.text = "Edge";
  } else if (edgeMode == true) {
    edgeMode = false;
    nodeMode = true;
    modeSwap.text = "Node";
  }
}

public void createNodes() {

  if (clickedOnNode(mouseX, mouseY, 50).id == '?' && nodes.length < 26 && (mouseX < (partition_x1-25) || mouseX > (partition_x1+25))) { //If we didnt click on a node
    Node newNode = new Node(mouseX, mouseY, PApplet.parseChar(nodes.length + 65));
    nodes = (Node[])append(nodes, newNode);
  }
}

public void createEdges() {
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


public Node clickedOnNode(int x, int y, int range) {
  int i;
  for (i=0; i<nodes.length; i++) {
    if ((x<=(nodes[i].xpos + range) && x>=(nodes[i].xpos - range)) && (y<=(nodes[i].ypos +range) && y>=(nodes[i].ypos - range))) {
      return nodes[i];
    }
  }
  Node error = new Node(-1, -1, '?');
  return error;
}
class Iteration {
  Node nodeList[];
  int cuts;
  boolean isBalanced;

  Iteration() {
    nodeList = new Node[0];
    for (int i = 0; i < nodes.length; i++) {
      nodeList = (Node[])append(nodeList, new Node());
      nodeList[i].makeCopy(nodes[i]);
    }
    cuts = netCuts;
    int temp = 0;
    for (int i = 0; i < nodeList.length; i++) {
      if (nodeList[i].partition == 'A') {
        temp++;
      }
    }
    if (((PApplet.parseFloat(temp)/nodeList.length)*100) > lowerBalanceCriteria && ((PApplet.parseFloat(temp)/nodeList.length)*100) <= upperBalanceCriteria) {
      isBalanced = true;
    } else {
      isBalanced = false;
    }
    //println((float(temp)/nodeList.length)*100 + "," + lowerBalanceCriteria + "," + upperBalanceCriteria + " is balanced? " + isBalanced);
  }

  public void load() {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i].makeCopy(nodeList[i]);
    }
  }
}
class Node { 
  float xpos, ypos; 
  char id;
  //Connection [] connections = {};
  boolean isFixed;
  int gain;
  char partition;
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
    gain = 0;
    partition = calculatePartition();
  }
  Node () {
    xpos = 0; 
    ypos = 0;
    id = ' ';
    isFixed = false;
    gain = 0;
    partition = 'c';
  }

  public void calculateGain() {
    //TODO
    int cut = 0;
    int uncut = 0;
    for (int i = 0; i<connections.length; i++) {
      if (connections[i].node1.id == this.id || connections[i].node2.id == this.id ) {
        if (connections[i].cut == true) {
          cut+=connections[i].weight;
        } else {
          uncut+=connections[i].weight;
        }
      }
    }
    gain = cut - uncut;
    partition = calculatePartition();
  }

  public char calculatePartition() {
    if (xpos > partition_x1) {
      return 'B';
    }
    return 'A';
  }

  public void makeCopy(Node copy) {
    this.xpos = copy.xpos;
    this.ypos = copy.ypos;
    this.id = copy.id;
    this.isFixed = copy.isFixed;
    this.gain = copy.gain;
    this.partition = copy.partition;
  }

  //void addConnection(Node new_node) {
  //  Connection new_connection = new Connection(this, new_node);
  //  connections = (Connection[])append(connections, new_connection);
  //}
}
  public void settings() {  size(700, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "sketch_507Project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
