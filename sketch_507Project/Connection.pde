class Connection { 
  Node node1, node2; 
  Connection (Node x, Node y) {  
    node1 = x; 
    node2 = y;
    cut = false;
    println("creating a connection between" + node1.id + " and " + node2.id);
  }
}
