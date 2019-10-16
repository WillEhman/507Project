class Node { 
  float xpos, ypos; 
  char id;
  Connection [] connections = {};
  boolean isFixed;
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
  }

  void addConnection(Node new_node) {
    Connection new_connection = new Connection(this, new_node);
    connections = (Connection[])append(connections, new_connection);
  }
}
