class ParticleController{
  ArrayList<Particle> mParticles;

  public ParticleController(){
    mParticles = new ArrayList<Particle>();
  }

  public void draw(){
    for(Particle particle:mParticles) {
      if(particle.life<=particle.ttl){
        particle.draw();
      }
    }
  }

  public void addParticle(color c){
      float x = random(0, width);
      float y = random(0, height);
      mParticles.add(new Particle(c));
  }

  public void removeParticles(int amount){
    if(mParticles.size()>0){
      for(int i=0;i<amount;i++){
        mParticles.remove(0);
      }
    }
  }
}

