//Establish the properties of the program window
void setup() {
  fullScreen(); //run the program at fullscreen
  frameRate(120); //runs by default at 120 fps, can be changed if there are framerate issues
  noCursor();
  logo = loadImage("Netcut.png"); //load the game logo

  //we set the global variables such that we always have access to the initial width and height of the screen
  screenwidth = width;
  screenheight = height;
  partition_x1 = 3*screenwidth/4; 
  reInitButtons(); //re-set the buttons so they fit properly on any screen size
}

//Call the functions to draw on the program window
void draw() {
  drawNoButtons(); //hide all buttons by default
  switch (ProgramState) {
    
  case 0: //The Menu case
    //Define the buttons to use in this screen
    play.draw = true;
    rules.draw = true;

    drawBackground(); //draw the background
    image(logo, width/2-735/2, 100); //draw the game logo

    drawEscape(); //Draw a text notice that the user must press escape to quit the game from main menu
    drawButtons(); //draw the buttons on the Menu
    break; //End of Menu case
    
  case 1: //The Rules case
    //Define the buttons to use in this screen
    mainMenu.draw=true;
    
    drawBackground();//draw the background
    drawRules(); //draw the rules text block
    drawButtons(); //draw the buttons on the ruels menu
    break; //End of Rules case
    
  case 2: //The Game case
    //Define the buttons to use in this screen
    if (!startedGame) {
      start.draw = true; //draw the start button if the game hasnt started yet
    }
    bestScore.draw = true;
    reset.draw = true;
    balanceCriteria.draw = true;
    quit.draw=true;
    if (playerFailed) {
      playerUnbalanced.draw=true; //if the player failed to draw a balanced partition, let them try again, but let them know they failed
    }

    drawGameLayout(); //draw the game background
    drawTimer(); //draw a timer bar so the player knows how much time he has left

    ////calculate the number of Net Cuts
    calculateGains();
    calculateCPUGains();

    //If player is done
    if (doneDrawingPartition && playerPartition.length > 1) {
      determineVictory(); //determine who won
    }
    
    //if the computer is done and the user is not, computer wins
    if (!startOptimizing && startedGame ) {
      gameOver = true;
      showPlayerVictory(false);
    }

    //RUN CPU AI
    ////If the start button has been pressed, run the optimization algorithm
    if (startOptimizing && !gameOver) {
      optimizeNetcuts(1000);
    }


    ////Draw the various parts of the User Interface
    drawPartition();
    drawPlayerPartition();
    drawConnections();
    drawNodes();
    drawButtons();
    drawCPUScore();
    drawPlayerScore();
    break; //End of Game case
    
  case 3: //Level select
    easy.draw=true;
    medium.draw=true;
    hard.draw=true;
    mainMenu.draw = true;
    drawBackground();
    drawButtons();
    break; //End of level select
    
  }
  drawCursor(); //in all cases, draw the cursor over everything else
}

//Pallette
//https://coolors.co/1c333d-0d7170-2a9e5c-9ddbb8-d4f4dd
//$color1: rgba(28, 51, 61, 1); dark blue
//$color2: rgba(13, 113, 112, 1); lighter dark blue
//$color3: rgba(42, 158, 92, 1); dark green
//$color4: rgba(157, 219, 184, 1); light green
//$color5: rgba(212, 244, 221, 1); light aqua
