//Custom class to describe a connection between nodes
class Connection { 
  Node node1, node2; //The 2 nodes being connected
  boolean cut; //If the connection is cut
  int weight; //The weight of the connection
  
  //Constructor to create a new connection.
  Connection (Node x, Node y) {  
    node1 = x; 
    node2 = y;
    cut = false;
    weight = 1;
  }
}
