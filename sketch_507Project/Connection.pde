class Connection { 
  Node node1, node2; 
  boolean cut;
  int weight;
  Connection (Node x, Node y) {  
    node1 = x; 
    node2 = y;
    cut = false;
    weight = 1;
  }
}
