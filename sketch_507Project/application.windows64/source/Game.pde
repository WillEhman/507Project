//start the game and initialize the status tracking variables
void startGame(){
 startOptimizing = true;
 startedGame = true;
 timerStart = millis();
}

//intialize all the variables and setup for a new game
void initGame(){
  reset();
  createRandomNodes(nodeCount);
  createRandomEdges(edgeCount);
  findBestScore();
}

//determine whether the player or the computer can claim victory
void determineVictory(){
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
