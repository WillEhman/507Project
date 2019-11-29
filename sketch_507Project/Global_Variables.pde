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
String partitioning = "Balance: " + str(ceil((lowerBalanceCriteria/100.0)*nodeCount)) + "/" + str(nodeCount); //a string to store the calculations of the balance criteria
Button balanceCriteria = new Button(screenwidth/2, screenheight-80, 190, 50, partitioning);  //The Balance Indicator
Button quit = new Button(screenwidth/2, screenheight-140, "Quit"); //The Quit button
Button easy = new Button(screenwidth/2, screenheight/2-100, "Easy"); //The easy button
Button medium = new Button(screenwidth/2, screenheight/2, "Medium"); //The medium button
Button hard = new Button(screenwidth/2, screenheight/2+100, "Hard"); //The hard button
Button playerUnbalanced = new Button(screenwidth/2, screenheight/2+100,  210, 50, "NOT BALANCED");  //The Unbalanced indicator
Iteration bestSave; //The best saved iteration, used to display the solution

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
  reInitButtons();
  playerUnbalanced = new Button(screenwidth/2, screenheight/2+100,  210, 50, "NOT BALANCED");
  startedGame = false;
  gameOver = false;
  playerFailed = false;
  gameTime = 0;
  timerStart = 0;
}
