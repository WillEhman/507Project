class Iteration {
  Node nodeList[];
  int cuts;

  Iteration() {
    nodeList = new Node[0];
    for (int i = 0; i < nodes.length; i++) {
      nodeList = (Node[])append(nodeList, new Node());
      nodeList[i].makeCopy(nodes[i]);
    }
  }

  void load() {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i].makeCopy(nodeList[i]);
    }
  }
}
