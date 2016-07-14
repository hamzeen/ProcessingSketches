import processing.video.*;

Capture cam;

int[] xs, ys;         // x and y coordinates of rectangle sources
                      // x[i],y[i] says which camera rectangle goes to window rectangle #1
PImage[] pieces;      // the image fragmented into rectangles
int nx=3, ny=3;       // number of rectangles across and down
int dx, dy;           // rectangle sizes, computed from width,height and nx,ny
int selX=-1,selY=-1;  // if a piece has been selected, its x and y indices (-1 if none)
boolean auto=false; // whether or not to auto swap pieces
int p;
String baseOrder = "";
boolean inOrder = false;
void setup() 
{
  size(640,480);
  noFill(); strokeWeight(3);
  
  cam = new Capture(this,640,480,2);
  cam.start();
  
  dx = width/nx; 
  dy = height/ny;

  // Initially, have our usual mapping, where piece at x+y*nx corresponds to (x,y)
  xs = new int[nx*ny];
  ys = new int[nx*ny];
  pieces = new PImage[nx*ny];
  p=0;
  for (int y=0; y<ny; y++) {
    for (int x=0; x<nx; x++) {
      xs[p] = x;
      ys[p] = y;
      baseOrder += xs[p]+""+ys[p]+"|";
      p++;
    }
  }

  // Mix up the rectangles
  //shuffle();
  stroke(255,0,0); noFill();
}

void draw()
{
  if (auto && frameCount % 30 == 0)
    swapPieces(int(random(pieces.length)), int(random(pieces.length)));
  
  // update the images of the pieces
    cam.read();
    p=0;  // which window piece we're currently drawing
    for (int y=0; y<ny; y++) {
      for (int x=0; x<nx; x++) {
        pieces[p] = cam.get(xs[p]*dx,ys[p]*dy,dx,dy);
        p++;
      }
    }
  
  // Draw the pieces at their positions 
  int p=0;
  for (int j=0; j<ny; j++) {
    for (int i=0; i<nx; i++) {
      image(pieces[p],dx*i,dy*j);
      // Outline the piece in black
      stroke(0);
      rect(dx*+i,dy*j,dx,dy);
      p++;
    }
  }
  // Outline selected one if needed
  if (selX >= 0 && selY >= 0) { 
    stroke(255,0,0);
    rect(dx*selX,dy*selY,dx,dy); // -1 to make sure red can be seen
  }
  if(!inOrder) {
    textAlign(LEFT);
    text("Game on",200,180); 
  } else {
    textAlign(LEFT);
    text("Weldone! Press S to shuffle & play again",200,180);
  }
} 

// Mix up all the pieces
void shuffle()
{
  // Swap each piece with some piece later in the array
  for (int i=0; i<xs.length; i++)
    swapPieces(i, int(random(i,xs.length)));
}

// Swap the pieces (both x and y values) at the two indices
void swapPieces(int i1, int i2)
{
  int x = xs[i1], y = ys[i1];
  xs[i1] = xs[i2]; ys[i1] = ys[i2];
  xs[i2] = x; ys[i2] = y;
  checkOrder();
}

void checkOrder() {
  String tempOrder = "";
  int n = 0;
  for (int y=0; y<ny; y++) {
    for (int x=0; x<nx; x++) {
      tempOrder += xs[n]+""+ys[n]+"|";
      n++;
    }
  }
  
  if(tempOrder.equals(baseOrder)) {
    println("Ordered!!");
    inOrder = true;
  }
}

void mousePressed()
{
  // Find which piece was clicked on
  int px = mouseX/dx, py = mouseY/dy;
  // Select two pieces to swap; same piece twice to cancel
  if (selX >= 0 && selY >= 0) {
    if (selX == px && selY == py) { // same one twice -- cancel
      selX = -1; selY = -1;
    }
    else { // second selection -- swap
      swapPieces(px+py*nx, selX+selY*nx);
      selX = -1; selY = -1;
    }
  }
  else { // first selection
    selX = px; selY = py;
  }
}

void keyPressed() {
  if (key == 'a') auto = !auto;
  else if (key == 's') shuffle();
}
