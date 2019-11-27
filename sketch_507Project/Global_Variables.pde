//All the global variables used in the program
int nodeCount = 5;
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
boolean startedGame = false;
int bestNetCut= 99999;
int ProgramState = 0; //0 is menu, 1 is rules, 2 is game
boolean gameOver = false;

//Buttons
Button [] buttons = new Button[0]; //The list of buttons

//Button modeSwap = new Button(550, 30, "Node");  //The mode swap button
//Button optimize = new Button(550, 100, "Optimize"); //The optimize button
Button start = new Button(screenwidth/2, screenheight/2, "Start"); //The Start button
Button bestScore = new Button(screenwidth/2, 100, str(bestNetCut));
Button reset = new Button(screenwidth/2, screenheight/2+200, "Reset");  //The reset button
//Button lowerBalanceSlider = new Button(550, 350, 10, 18, ""); //The slider to set the lower bound of the balance criteria
//Button upperBalanceSlider = new Button(650, 350, 10, 18, ""); //The slider to set the upper bound of the balance criteria
Button play = new Button(screenwidth/2, screenheight/2-50, "Play");
Button rules = new Button(screenwidth/2, screenheight/2+50, "Reset");
String partitioning = "Balance: " + str(ceil((lowerBalanceCriteria/100.0)*nodeCount)) + "/" + str(nodeCount);
Button balanceCriteria = new Button(screenwidth/2, screenheight-80, 190, 50, partitioning);

//Function to reset the program to the initial conditions
void reset() {
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
  buttons = new Button[0]; 
  start = new Button(screenwidth/2, screenheight/2, "Start");
  bestScore = new Button(screenwidth/2, 100, str(bestNetCut));
  reset = new Button(screenwidth/2, screenheight/2+200, "Reset");
  startedGame = false;
  createRandomNodes(5);
  createRandomEdges(30);
  findBestScore();
  gameOver = false;
}
