
int n = 1000;
int maxage = 20;
int rdodge = 30;
int opacity = 50;
float speed = .2;
float zoom = .01;
boolean crayons, soft, dodge = true;

float[][] a = new float[n][2];
int[] age = new int[n];
float w, h, s;
int t, c;
color COLOR;

ParticleController mParticleController;

void setup() {
  size(1000, 800);
  mParticleController = new ParticleController();

  w = width/2;
  h = height/2;
  colorMode(HSB, TWO_PI, 2, 1);
  smooth();
  strokeCap(ROUND);strokeJoin(MITER);
  reset();
}


void draw() {
  mParticleController.draw();
  // create new particles
  int np = n / maxage;
  for(int i=0; i<np & c<n; i++, c++) newp(c);
  // draw particle traces
  for(int i=0; i<c; i++) {
    age[i]++;
    float[] p = a[i];
    if (age[i] > maxage) newp(i);
    else {
      float[] f = f(p[0], p[1]);     
      int m = maxage/2;
      float o = mag(f[0], f[1]) * 2 * opacity;
      // hue based on direction
      float h =  atan2(f[0], f[1]) + PI;   
      COLOR = color(h, int(random(0,255)), int(random(0,255)), o);
      stroke(COLOR); 
      // draw line while updating position
      line(p[0], p[1], p[0] += s*f[0],  p[1] += s*f[1]);
    }
  }
}


// noise based flow field
float[] f(float x, float y) {;
  return new float[] {
    noise(t, x * zoom, y * zoom)-.5,
    noise(t+1, x * zoom, y * zoom) - .5
  };
}


void newp(int p) {
  if(dodge) { 
    // particle inside a circle around the mouse position
    float r = random(rdodge), ang = random(TWO_PI);
    a[p] = new float[] { mouseX + r * cos(ang), mouseY + r *sin(ang) };
    if(frameCount %60== 0) {
      mParticleController.addParticle(COLOR);
    }
    
  } else {  
    // particle anywhere on screen
    a[p] = new float[] { random(width), random(height) };
  }
  age[p] = 0;
}


void reset() {
  background(crayons ? #ffffff : #ffffff);
  s = speed / zoom;
  c = 0;
}
  

void keyPressed() { 
  switch(key) {
    case 's' : soft = !soft; break;
    case 'd' : dodge = !dodge; break;
    case 'f' : t++; break;
    case 'c' : crayons = !crayons; break;
    case '+' : zoom /= 1.1; break;
    case '-' : zoom *= 1.1; break;
    case ' ' : break;
    default: return;
  } 
  reset();
}

