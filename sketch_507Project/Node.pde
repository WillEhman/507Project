class Node { 
  float xpos, ypos; 
  char id;
  char [] connections = new char[0];
  boolean isFixed;
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
  }

  void addConnection(char new_node) {
    connections = (char[])append(connections, new_node);
  }
}
