//Establish the properties of the program window
void setup() {
  size(1200, 800);
  frameRate(120);
  noCursor();
  createRandomNodes(6);
  createRandomEdges(30);
  findBestScore();
}

//Call the funcitons to draw on the program window
void draw() {
  drawGameLayout();

  ////calculate the number of Net Cuts
  calculateGains();
  calculateCPUGains();

  //If player is done
  if (doneDrawingPartition && playerPartition.length > 1) {
    startedGame = false;
    netCuts = countNetcuts(nodes, connections, playerPartition);
    Iteration currentIteration = new Iteration(nodes);

    boolean balanced = false;
    int temp = 0;
    //Calculate if the iteration meets the balance criteria
    //Iterate through all nodes
    for (int j = 0; j < currentIteration.nodeList.length; j++) {
      //Is the node in partition A?
      if (currentIteration.nodeList[j].partition == 'A') {
        //Increase the count of nodes in partition A
        println(currentIteration.nodeList[j].id, "is in A");
        temp++;
      }
    }

    //Does the percentage of nodes in partition A meet the balance criteria
    println(temp);
    println(float(temp)/currentIteration.nodeList.length*100);
    if (((float(temp)/currentIteration.nodeList.length)*100) > lowerBalanceCriteria && ((float(temp)/currentIteration.nodeList.length)*100) <= upperBalanceCriteria) {
      balanced =  true;
    }else{
      balanced =  false;
    }

    if (netCuts <= bestNetCut) {
      if (balanced) {
        showPlayerVictory(true);
      } else {
        showUnbalanced();
      }
    } else {
      showPlayerVictory(false);
    }
  }


  //TODO handle if CPU finishes first
  //if (!startedGame && !doneDrawingPartition){
  //  showPlayerVictory(false);
  //}

  //RUN CPU AI
  ////If the start button has been pressed, run the optimization algorithm
  if (startedGame) {
    optimizeNetcuts(1000);
  }


  ////Draw the various parts of the User Interface
  drawPartition();
  drawPlayerPartition();
  drawConnections();
  drawCPUConnections();
  drawNodes();
  drawButtons();
  drawCursor();
  drawCPUScore();
  drawPlayerScore();
}

//Pallette
//https://coolors.co/1c333d-0d7170-2a9e5c-9ddbb8-d4f4dd
//$color1: rgba(28, 51, 61, 1); dark blue (backgrounds)
//$color2: rgba(13, 113, 112, 1); lighter dark blue (background details)
//$color3: rgba(42, 158, 92, 1); dark green (node outline)
//$color4: rgba(157, 219, 184, 1); light green (node fill)
//$color5: rgba(212, 244, 221, 1); light aqua (text)
