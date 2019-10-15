class Node { 
  float xpos, ypos; 
  char id;
  char [] connections = new char[0];
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
  }

  void addConnection(char new_node) {
    connections = (char[])append(connections, new_node);
  }
}
