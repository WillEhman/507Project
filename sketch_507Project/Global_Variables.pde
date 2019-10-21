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

void reset() {
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
