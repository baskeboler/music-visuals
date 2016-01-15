 //<>// //<>// //<>//
public class ImageManager { //<>//
  private ArrayList<PImage> images = new ArrayList();
  private int updateInterval = 50;
  private int transitionInterval = 120;
  private PImage mainImage;
  private PImage altImage;
  private PApplet parent;
  private int lastTransitionTimestamp;
  private int lastUpdateTimestamp;
  // private PMatrix2D matrix;
  private float scale;
  private PVector pos;

  ArrayList<Effect> effects;
  Effect currentEffect;
  int beat = 0;

  public ImageManager(PApplet parent, String imagePath) {
    this.parent = parent;
    println("Creating imagemanager");
    effects = new ArrayList<Effect>();
    // this.fire.speed(3);
    this.mainImage = parent.loadImage(imagePath);
    println("main image loaded");
    this.init();
  }

  private void init() {
    // renderImage.init(,,, )
    this.lastTransitionTimestamp = second();
    this.lastUpdateTimestamp = millis();
    this.scale = 1f;
    this.pos = new PVector(parent.width/2, parent.height/2);
    altImage = loadImage("picture.png");
    Effect fireEffect = new VideoEffect(this, "fire.mp4");
    AudioWaveEffect waveEffect = null;
    this.effects.add(fireEffect);
    this.currentEffect = fireEffect;
    PShader s;
    String[] sFiles = new String[] {"spiral.glsl", "redsmoke.glsl", "sea.glsl", "desert.glsl", "nebula.glsl", "hell.glsl", "snowy.glsl", "stardust.glsl", "clouds.glsl", "generators.glsl", "inversion.glsl", "star.glsl"};
    String [] sChannel0s = new String[] {"texNoise.png","texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "texNoise.png", "tex09.jpg"};
    int i = 0;
    for (String fileName : sFiles) {
      s = parent.loadShader(fileName);
      PApplet.println("shader " + fileName + " loaded");
      waveEffect = new AudioWaveEffect(this, s, fileName);
      waveEffect.channel0 = loadImage(sChannel0s[i]);
      if (waveEffect.channel0 != null) {
        println(sChannel0s[i]  + " loaded succesfully for shader " + fileName);
      }
      this.effects.add(waveEffect);
      i++;
    }
    this.effects.add(new FFTShaderEffect(this, in));

    println("alpha mask loaded and resized");
  }

  private void update() {
    int now = millis();
    if (now - this.lastUpdateTimestamp > this.updateInterval) {
      // update code
      //this.setScale(map(beat, 0, 100, 1, 1.5));
      this.setPos(parent.width/2, parent.height/2);
      this.lastUpdateTimestamp = now;

      //if (fire.available()) {
      //  fire.read();
      //}
      //renderImage.
    }
    now = PApplet.second();
    if (now - this.lastTransitionTimestamp > this.transitionInterval) {
      println("transition trigger");
      modeTransition();
      this.lastTransitionTimestamp = now;
    }
  }

  public void modeTransition() {
    println("Deactivating " + this.currentEffect);
    this.currentEffect.deactivate();
    boolean check = false;
    Effect next = null;
    for (Effect e : this.effects) {
      if (check) {
        next = e;
        break;
      }
      if (e == this.currentEffect) {
        check = true;
      }
    }
    if (next == null)
      next = this.effects.get(0);
    this.currentEffect = next;
    println("Activating " + next);
    this.currentEffect.activate();
  }



  public void setPos(float x, float y) {
    this.pos.x = x;
    this.pos.y = y;
    this.pos.z = 0;
  }

  public void setScale(float x) {
    this.scale = x;
  }

  public void draw() {
    this.update();
    currentEffect.draw();
    updateBeat();
  }

  public void imageBumpMode() {
    int picAlpha = int(map(beat, 0, 100, 0, 255));

    parent.pushMatrix();
    translate(this.pos.x, this.pos.y);
    scale(this.scale);
    parent.imageMode(CENTER);
    tint(255, 255);

    image(this.mainImage, 0, 0, this.parent.width, this.parent.height);
    // image(fire, 0, 0, this.parent.width, this.parent.height);

    parent.popMatrix();
    pushMatrix();
    translate(parent.width/2, parent.height/2);
    blendMode(BLEND);
    tint(255, 0, 0, picAlpha);
    image(altImage, 0, 0, parent.width, parent.height);
    popMatrix();
  }

  public void dispose() {
    println("running imagemanager dispose");
    for (Effect e : this.effects)
      e.dispose();
    this.effects.clear();
    this.effects = null;
    this.images.clear();
    this.images = null;
    //this.renderImage = null;
  }

  public void beat() {
    this.beat = 100;
  }

  public void updateBeat() {
    this.beat = (this.beat - 5 >= 0)? this.beat - 5 : 0;
  }

  public void addImage(PImage im) {
    this.images.add(im);
    //im.resize(renderImage.width, renderImage.height);
    altImage = im;
  }

  //public void movieEvent(Movie m) {
  //  m.read();
  //}
  public PApplet getParent() {
    return this.parent;
  }

  public float getScale() {
    return this.scale;
  }
}