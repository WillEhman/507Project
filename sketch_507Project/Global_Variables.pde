//All the global variables used in the program
int screenwidth = 1200;
int screenheight = 800;
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
boolean startOptimizing = false; //Should the program run the optimization fully?
int startTime; //The time at the start of a function
int lowerBalanceCriteria = 20; //The lower bound of the balance criteria
int upperBalanceCriteria = 80; //The upper bound of the balance criteria
boolean noMoreNodes = false; //Allow more nodes/edges to be drawn?
Point playerPartition[] = new Point[0]; //Array containing the points that make up the player partition
boolean doneDrawingPartition = false; //Are we done drawing the partition
int lastX = 0; //The last X position clicked
int lastY = 0; //The last Y position clicked

//Buttons
Button [] buttons = new Button[0]; //The list of buttons

//Button modeSwap = new Button(550, 30, "Node");  //The mode swap button
//Button optimize = new Button(550, 100, "Optimize"); //The optimize button
Button start = new Button(screenwidth/2, screenheight/2, "Start"); //The step button
//Button reset = new Button(550, 240, "Reset");  //The reset button
//Button lowerBalanceSlider = new Button(550, 350, 10, 18, ""); //The slider to set the lower bound of the balance criteria
//Button upperBalanceSlider = new Button(650, 350, 10, 18, ""); //The slider to set the upper bound of the balance criteria

//Function to reset the program to the initial conditions
void reset() {
  nodes = new Node[0];
  connections = new Connection[0];
  save = new Iteration[0];
  firstNode = new Node();
  startOptimizing = false;
  lowerBalanceCriteria = 20;
  upperBalanceCriteria = 80;
  noMoreNodes = false;
  //modeSwap.textColor=0;
  //lowerBalanceSlider.x = 550;
  //upperBalanceSlider.x = 640;
  nodeMode = true;
  edgeMode = false;
  firstEdge = true;
}
