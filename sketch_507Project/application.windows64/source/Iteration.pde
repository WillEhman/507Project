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
  
  boolean checkBalanced(){
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
    if (((float(temp)/nodeList.length)*100) > lowerBalanceCriteria && ((float(temp)/nodeList.length)*100) <= upperBalanceCriteria) {
      return true;
    }
    return false;
  }

  //Function to make this iteration the current display
  void load() {
    //Iterate through all the nodes
    for (int i = 0; i < computernodes.length; i++) {
      //Copy the nodes from this iteration into the display
      computernodes[i].makeCopy(nodeList[i]);
    }
  }
}
