//Custom class to describe all the button properties
class Button { 
  int x, y; //The x and y position of the button
  int w, h; //The width and height of the button
  String text; //The text in the button
  int textColor = 0; //The colour of the button
  boolean draw = true;
  boolean hoverable = true;

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
    stroke(212, 244, 221);
    strokeWeight(1);
    buttonHovered();
    rect(x-(w/2), y, w, h);
    fill(212, 244, 221);
    textAlign(CENTER);
    textSize(26);
    text(text, x+2, y+h-12);
  }

  //Funcition to check if the button has been pressed
  boolean isPressed(int mousex, int mousey) {
    if ((mousex >= x-(w/2) && mousex < x+(w/2)) && (mousey >= y && mousey < y+h)) {
      //The button has been pressed
      return true;
    }
    //The button has not been pressed
    return false;
  }
  
  //if the mouse is over the button, draw it with a slightly lighter colour to indicate it is being hovered
  void buttonHovered() {
    if ((mouseX >= x-(w/2) && mouseX < x+(w/2)) && (mouseY >= y && mouseY < y+h) && hoverable) {
      fill(58, 81, 91);
    } else {
      fill(28, 51, 61);
    }
  }
}

//re-initialize the buttons to their initial state
void reInitButtons(){
  buttons = new Button[0]; //The list of buttons
  start = new Button(screenwidth/2, screenheight/2, "Start"); //The Start button
  bestScore = new Button(screenwidth/2, 100, str(bestNetCut));
  reset = new Button(screenwidth/2, screenheight/2+200, "Reset");  //The reset button
  play = new Button(screenwidth/2, screenheight/2-50, "Play");
  rules = new Button(screenwidth/2, screenheight/2+50, "Rules");
  mainMenu = new Button(screenwidth/2, screenheight/2+300, 200, 50, "Main Menu");
  balanceCriteria = new Button(screenwidth/2, screenheight-80, 190, 50, partitioning); 
  quit = new Button(screenwidth/2, screenheight-140, "Quit");
  easy = new Button(screenwidth/2, screenheight/2-100, "Easy");
  medium = new Button(screenwidth/2, screenheight/2, "Medium");
  hard = new Button(screenwidth/2, screenheight/2+100, "Hard");
}
