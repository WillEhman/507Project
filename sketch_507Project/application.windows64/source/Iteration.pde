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
    if (((float(temp)/nodeList.length)*100) > lowerBalanceCriteria && ((float(temp)/nodeList.length)*100) <= upperBalanceCriteria) {
      isBalanced = true;
    } else {
      isBalanced = false;
    }
    //println((float(temp)/nodeList.length)*100 + "," + lowerBalanceCriteria + "," + upperBalanceCriteria + " is balanced? " + isBalanced);
  }

  void load() {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i].makeCopy(nodeList[i]);
    }
  }
}
