class Iteration {
  char nodeIds[] = new char[0];
  
  Iteration(){
    for (int i = 0; i < nodes.length; i++){
      if (nodes[i].partition == 'A') {
        nodeIds = append(nodeIds, nodes[i].id);
      }
    }
  }
}
