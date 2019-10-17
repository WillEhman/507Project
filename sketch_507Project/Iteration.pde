class Iteration {
  char nodeIds[] = new char[0];
  
  void addNode(Node newNode) {
    append(nodeIds, newNode.id);
  }
}
