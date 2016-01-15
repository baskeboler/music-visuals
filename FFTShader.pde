class FFTShaderEffect implements Effect {

  PShader shader;
  AudioInput in;
  PApplet app;
  FFT fft;
  int startMillis;
  FFTShaderEffect(ImageManager parent, AudioInput in) {
    this.in = in;
    this.app = parent.getParent();
    this.startMillis = app.millis();
    this.shader = loadShader("sound.glsl");
    this.shader.set("resolution", float(app.width), float(app.height));
    this.fft = new FFT(in.bufferSize(), in.sampleRate());
  }

  void activate() {
  }

  void deactivate() {
  }

  void draw() {
    this.fft.forward(this.in.mix);
    AudioBuffer b = this.in.mix;
    PImage te = app.createImage(512, 2, RGB);

    for (int i = 0; i < this.fft.specSize(); i++) {
      te.set(i, 0, color(this.fft.getBand(i)*50));
      te.set(i, 1, color(100+b.get(i)*300));
    }

    te.updatePixels();
    int m = app.millis();
    this.shader.set("iChannel0", te);
    this.shader.set("resolution", float(app.width), float(app.height));
    
    this.shader.set("time", float(m-this.startMillis)/1000.0);
    app.shader(this.shader);
    app.noStroke();
    app.fill(0);
    app.rect(0, 0, app.width, app.height);  

    app.resetShader();
  }

  void dispose() {
  }
}