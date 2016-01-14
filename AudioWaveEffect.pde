class AudioWaveEffect implements Effect {
  ImageManager parent;
  PApplet app;
  AudioInput in;
  PShader nebula;
  int oldMillis;
  public AudioWaveEffect(ImageManager parent) {
    this.parent = parent;
    this.app = parent.getParent();
    in = ((songVisuals)app).in;
    oldMillis = app.millis();
    //noStroke();

    nebula = loadShader("snowy.glsl");

    nebula.set("resolution", float(app.width), float(app.height));
  }

  void activate() {
  }

  void deactivate() {
  }

  void draw() {
background(0);
    int m = millis();
    nebula.set("time", m / 5000.0);
    shader(nebula);
    rect(0, 0, app.width, app.height);
    resetShader();
    stroke(255, 0, 0);
    //    strokeWeight(3);
    //  noFill();
    AudioBuffer l = in.left, r = in.right;
    //for (int i = 0; i < in.bufferSize() - 1; i++) {
    //  float x1 = map(i, 0, in.bufferSize(), 0, app.width);
    //  float x2 = map(i+1, 0, in.bufferSize(), 0, app.width);
    //  line(x1, app.height/2 + l.get(i)*50, x2, app.height/2+ l.get(i+1)*50);
    //}

    //app.beginShape();
    //for (int i = 0; i < in.bufferSize(); i++) {
    //  float x1 = map(i, 0, in.bufferSize(), 0, app.width);
    //  app.curveVertex(x1, app.height/2 + l.get(i)*1000);
    //}
    //app.endShape();

    for (int i = 0; i < in.bufferSize() - 1; i++) {
      float x1 = map(i, 0, in.bufferSize(), 0, app.width);
      float x2 = map(i+1, 0, in.bufferSize(), 0, app.width);
      float val = l.get(i)*1000;

      rect(x1, app.height/2 - val, x2-x1, val);

      //line(x1, app.height/2 + l.get(i)*50, x2, app.height/2+ l.get(i+1)*50);
    }
  }

  void dispose() {
  }
}