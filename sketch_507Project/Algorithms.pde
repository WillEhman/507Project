
int countNetcuts() {
  int cuts = 0;
  if (nodes.length > 0) {
    for (int i = 0; i < nodes.length; i++) {
      //Algorithm http://jeffreythompson.org/collision-detection/line-line.php
      for (int j = 0; j<nodes[i].connections.length; j++) {
        Node node1 = nodes[i];
        Node node2 = nodes[findNode(nodes[i].connections[j])];
        float x1 = node1.xpos;
        float x2 = node2.xpos;
        float y1 = node1.ypos;
        float y2 = node2.ypos;

        float x3 = partition_x1;
        float x4 = partition_x2;
        float y3 = 0;
        float y4 = 500;

        float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
          cuts++;
        }
      }
    }
  }
  return cuts;
}

int findNode(char c) {
  for (int i = 0; i<nodes.length; i++) {
    if (nodes[i].id == c) {
      return i;
    }
  }
  return -1;
}
