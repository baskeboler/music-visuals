class AudioWaveEffect implements Effect {
  ImageManager parent;
  PApplet app;
  AudioInput in;
  PShader shader;
  int oldMillis;
  PImage channel0;
  PImage channel1;
  float strokeWeight = 3;
  int startSeconds;
  int startMillis;
  FFT fft;
  String name;
  public AudioWaveEffect(ImageManager parent, PShader s, String name) {
    this.parent = parent;
    this.app = parent.getParent();
    in = ((songVisuals)app).in;
    this.startMillis = app.millis();
    this.startSeconds = app.second();
    //noStroke();
    //this.channel0 = app.loadImage("texNoise.png");
    shader = s;

    //shader.set("resolution", float(app.width), float(app.height));
    //    shader.set("iChannel0", texNoise);
    //  shader.set("iChannelResolution[0]", float(texNoise.width), float(texNoise.height), 0.0);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    fft.linAverages(4);
  }
  public String toString() {
    return "AudioWaveEffect-" + name;
  }
  void activate() {
  }

  void deactivate() {
  }

  void draw() {
    background(0);
    int m = millis();
    int s = second();
    fft.forward(in.mix);
    float factor = 20;
    float freqs[] = new float[] {fft.getBand(0)*factor, fft.getBand(1)*factor, fft.getBand(2)*factor, fft.getBand(3)*factor};
    PImage freqImage = app.createImage(4, 1, ARGB);
    for (int i = 0; i < 4; i++)
      freqImage.set(i, 0, color(freqs[i]));
    // printArray(freqs);
    shader.set("iChannel1", freqImage);
     shader.set("iChannelResolution[1]", 4, 1, 0.0);
    shader.set("iChannelTime[1]", float(m - this.startMillis)*0.001);
    shader.set("resolution", float(app.width), float(app.height));
    shader.set("mouse", float(app.mouseX), float(app.mouseY));
    shader.set("iChannel0", channel0);
    shader.set("iChannelResolution[0]", float(channel0.width), float(channel0.height), 0.0);
    shader.set("iChannelTime[0]", float(m - this.startMillis)*0.001);
    shader.set("time", float(m - this.startMillis)*0.001);//float(m / 5000.0));
    shader(this.shader, TRIANGLES);
    noStroke();
    fill(0);  
    rect(0, 0, app.width, app.height);
    stroke(255, 0, 0);
    strokeWeight(this.strokeWeight);
    //  noFill();
    AudioBuffer l = in.mix;
    for (int i = 0; i < in.bufferSize() - 1; i++) {
      float x1 = map(i, 0, in.bufferSize(), 0, app.width);
      float x2 = map(i+1, 0, in.bufferSize(), 0, app.width);
      line(x1, app.height/2 + l.get(i)*500, x2, app.height/2+ l.get(i+1)*500);
    }

    ////noFill();
    //app.beginShape();
    //for (int i = 0; i < in.bufferSize(); i++) {
    //  float x1 = map(i, 0, in.bufferSize(), 0, app.width);
    //  app.curveVertex(x1, app.height/2 + l.get(i)*1000);
    //}
    //app.endShape();

    //for (int i = 0; i < in.bufferSize() - 1; i++) {
    //  float x1 = map(i, 0, in.bufferSize(), 0, app.width);
    //  float x2 = map(i+1, 0, in.bufferSize(), 0, app.width);
    //  float val = l.get(i)*1000;

    //  rect(x1, app.height/2 - val, x2-x1, val);

    //  //line(x1, app.height/2 + l.get(i)*50, x2, app.height/2+ l.get(i+1)*50);
    //}
    resetShader();
    
  }

  void dispose() {
  }
}