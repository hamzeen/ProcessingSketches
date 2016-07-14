class Particle {
  float pX;
  float pY;
  float pVel;
  float pRadius;
  color pColor;
  
  float xoff = 0.0;
  float yoff = 0.0;
  float s, t;
  public int life = 0;
  int ttl;

  public Particle(color c) {
    this(netX,netY,c);
  }

  public Particle(int x, int y, color c) {
    pX = x;
    pY = y;
    ttl = int(random(40,100));
    pColor = c;
  }

  void draw() {
   fill(pColor);
    noStroke();
    ellipse (pX, pY, s, t);
    s = noise(xoff)*5;
    xoff -= 0.01;
    pY = pY + 1;
    t = noise(yoff)*8;
    yoff -= 0.01;
    life++;

  }
}

