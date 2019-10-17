class Node { 
  float xpos, ypos; 
  char id;
  //Connection [] connections = {};
  boolean isFixed;
  int gain;
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
    gain = 0;
  }

  void calculateGain() {
    //TODO
    int cut = 0;
    int uncut = 0;
    for (int i = 0; i<connections.length; i++) {
      if (connections[i].node1.id == this.id || connections[i].node2.id == this.id ) {
        if (connections[i].cut == true) {
          cut+=connections[i].weight;
        } else {
          uncut+=connections[i].weight;
        }
      }
    }
    gain = cut - uncut;
  }

  //void addConnection(Node new_node) {
  //  Connection new_connection = new Connection(this, new_node);
  //  connections = (Connection[])append(connections, new_connection);
  //}
}
