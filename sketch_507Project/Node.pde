class Node { 
  float xpos, ypos; 
  char id;
  //Connection [] connections = {};
  boolean isFixed;
  int gain;
  char partition;
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
    gain = 0;
    partition = calculatePartition();
  }
  Node () {
    xpos = 0; 
    ypos = 0;
    id = ' ';
    isFixed = false;
    gain = 0;
    partition = 'c';
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
    partition = calculatePartition();
  }

  char calculatePartition() {
    if (xpos > partition_x1) {
      return 'B';
    }
    return 'A';
  }

  void makeCopy(Node copy) {
    this.xpos = copy.xpos;
    this.ypos = copy.ypos;
    this.id = copy.id;
    this.isFixed = copy.isFixed;
    this.gain = copy.gain;
    this.partition = copy.partition;
  }

  //void addConnection(Node new_node) {
  //  Connection new_connection = new Connection(this, new_node);
  //  connections = (Connection[])append(connections, new_connection);
  //}
}
