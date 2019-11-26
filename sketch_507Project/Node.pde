//Custom class to describe nodes
class Node { 
  float xpos, ypos; //The x and y position of the node
  char id; //The identifier for the node
  boolean isFixed; //Has this node been fixed in place by the optimization process
  int gain; //The gain of the node
  char partition; //Which partition the node is in

  //Custom constructor to create a node
  Node (float x, float y, char node_id) {  
    xpos = x; 
    ypos = y;
    id = node_id;
    isFixed = false;
    gain = 0;
    partition = calculatePartition();
  }

  //Custom constructor to create an unlabelled node
  Node (float x, float y) {  
    xpos = x; 
    ypos = y;
    id = char(nodes.length+65);
    isFixed = false;
    gain = 0;
    partition = calculatePartition();
  }

  //Custom constructor to create a blank node
  Node () {
    xpos = 0; 
    ypos = 0;
    id = 20;
    isFixed = false;
    gain = 0;
    partition = 'c';
  }

  //Function to calculate the gain of the node
  void calculateGain() {
    int cut = 0; //The number of cut connections
    int uncut = 0; //The number of uncut connections
    //Iterate through all the connections 
    for (int i = 0; i<connections.length; i++) {
      //Is the connection cut?
      if (connections[i].node1.id == this.id || connections[i].node2.id == this.id ) {
        if (connections[i].cut == true) {
          cut+=1;
        } else {
          uncut+=connections[i].weight;
        }
      }
    }
    //Calculate the gain
    gain = cut - uncut;
    partition = calculatePartition(playerPartition);
  }

  //Function to calculate the gain of the node
  void calculateCPUGain() {
    int cut = 0; //The number of cut connections
    int uncut = 0; //The number of uncut connections
    //Iterate through all the connections 
    for (int i = 0; i<cpuconnections.length; i++) {
      //Is the connection cut?
      if (cpuconnections[i].node1.id == this.id || cpuconnections[i].node2.id == this.id ) {
        if (cpuconnections[i].cut == true) {
          cut+=1;
        } else {
          uncut+=cpuconnections[i].weight;
        }
      }
    }
    //Calculate the gain
    gain = cut - uncut;
    partition = calculatePartition();
  }

  //Function to determine which partition the node is in
  char calculatePartition() {
    //Is the node in partition B?
    if (xpos > partition_x1) {
      //Return partition B
      return 'B';
    }
    //Return partition A
    return 'A';
  }
  //Function to determine which partition the node is in
  char calculatePartition(Point [] pointarray) {
    //Is the node in partition B?

    //extend point to infinity to the right
    Point p1 = new Point(xpos, ypos);
    Point p2 = new Point(width, ypos);

    //run for all of the user partition
    if (pointarray.length > 1) {
      boolean intersection = false;
      int count = 0;
      for (int i = 1; i < pointarray.length; i++) {
        Point p3 = new Point(pointarray[i-1].xpos, pointarray[i-1].ypos);
        Point p4 = new Point(pointarray[i].xpos, pointarray[i].ypos);
        
        if (checkIntersection(p1, p2, p3, p4)) {
          count++;
        }
      }
      if (count%2 == 1){ //If there is an odd number of lines to the right of the node
        return 'A';
      }
    }
    return 'B';
  }

  //Function to make a copy of the node
  void makeCopy(Node copy) {
    this.xpos = copy.xpos;
    this.ypos = copy.ypos;
    this.id = copy.id;
    this.isFixed = copy.isFixed;
    this.gain = copy.gain;
    this.partition = copy.partition;
  }
}
