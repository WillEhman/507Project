class Iteration {
  Node nodeList[] = new Node[0];
  int cuts;

  Iteration() {
    for (int i = 0; i < nodes.length; i++) {
      nodeList = (Node[])append(nodeList, nodes[i]);
    }
    cuts = netCuts;
  }

  void load() {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i] = nodeList[i];
    }
    netCuts = cuts;
  }
}
