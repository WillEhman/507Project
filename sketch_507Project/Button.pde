class Button { 
  int x, y;
  int w, h;
  String text;
  Button (int myX, int myY, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = 120;
    h = 50;
    buttons = (Button[])append(buttons,this);
  }
  void drawButton(){
    stroke(0,0,0);
    fill(255);
    rect(x,y,w,h);
    fill(0);
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
