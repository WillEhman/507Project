void startGame(){
 //TODO Implement 
 startOptimizing = true;
 startedGame = true;
 start.draw=false;
}

void initGame(){
  reset();
  createRandomNodes(nodeCount);
  createRandomEdges(edgeCount);
  findBestScore();
}

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
