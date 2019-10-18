class Button { 
  int x, y;
  int w, h;
  String text;
  int textColor = 0;
  Button (int myX, int myY, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = 120;
    h = 50;
    buttons = (Button[])append(buttons,this);
  }
  Button (int myX, int myY, int myW, int myH, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = myW;
    h = myH;
    buttons = (Button[])append(buttons,this);
  }
  void drawButton(){
    stroke(0,0,0);
    fill(255);
    rect(x,y,w,h);
    fill(textColor);
    textSize(20);
    text(text, x+2, y+h-12);
  }
  boolean isPressed(int mousex, int mousey){
    if ((mousex >= x && mousex < x+w) && (mousey >= y && mousey < y+h)){
      return true;
    }
    return false;
  }
}
