//Custom class to describe all the button properties
class Button { 
  int x, y; //The x and y position of the button
  int w, h; //The width and height of the button
  String text; //The text in the button
  int textColor = 0; //The colour of the button
  
  //Constructor for creating a button of default height and width, with custom text, x, and y position
  Button (int myX, int myY, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = 120;
    h = 50;
    buttons = (Button[])append(buttons, this); //Add the new button to the list of buttons
  }
  
  //Constructor for creating a button with custom height, width, text, x, and y position
  Button (int myX, int myY, int myW, int myH, String label) {  
    x = myX; 
    y = myY;
    text = label;
    w = myW;
    h = myH;
    buttons = (Button[])append(buttons, this); //Add the new button to the list of buttons
  }
  
  //Function to draw the button
  void drawButton() {
    stroke(0, 0, 0);
    fill(255);
    rect(x, y, w, h);
    fill(textColor);
    textSize(20);
    text(text, x+2, y+h-12);
  }
  
  //Funcition to check if the button has been pressed
  boolean isPressed(int mousex, int mousey) {
    if ((mousex >= x && mousex < x+w) && (mousey >= y && mousey < y+h)) {
      //The button has been pressed
      return true;
    }
    //The button has not been pressed
    return false;
  }
}
