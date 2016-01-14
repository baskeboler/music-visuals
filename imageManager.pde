public class ImageManager { //<>// //<>//
  private ArrayList<PImage> images = new ArrayList();
  private int updateInterval = 50;
  private int transitionInterval = 10;
  private PImage mainImage;
  private PImage altImage;
  private PImage renderImage;
  private PApplet parent;
  private int lastTransitionTimestamp;
  private int lastUpdateTimestamp;
  // private PMatrix2D matrix;
  private float scale;
  private PVector pos;
  VideoEffect fireEffect;
  AudioWaveEffect waveEffect;
  int beat = 0;

  public ImageManager(PApplet parent, String imagePath) {
    this.parent = parent;
    println("Creating imagemanager");

    // this.fire.speed(3);
    this.mainImage = parent.loadImage(imagePath);
    println("main image loaded");
    this.renderImage = this.mainImage;
    println("render image created");
    //parent.applyMatrix(
    // this.matrix = new PMatrix2D();
    //this.matrix.reset();
    println("imagemanager matrix initialized");
    this.init();
  }

  private void init() {
    // renderImage.init(,,, )
    this.lastTransitionTimestamp = second();
    this.lastUpdateTimestamp = millis();
    this.scale = 1f;
    this.pos = new PVector(parent.width/2, parent.height/2);
    altImage = loadImage("picture.png");
    //alphaMask.filter(GRAY);
    //alphaMask.resize(renderImage.width, renderImage.height);
    //renderImage.mask(alphaMask);
    fireEffect = new VideoEffect(this, "fire.mp4");
    waveEffect = new AudioWaveEffect(this);
    println("alpha mask loaded and resized");
  }

  private void update() {
    int now = millis();
    if (now - this.lastUpdateTimestamp > this.updateInterval) {
      // update code
      this.setScale(map(beat, 0, 100, 1, 1.5));
      this.setPos(parent.width/2, parent.height/2);
      this.lastUpdateTimestamp = now;

      //if (fire.available()) {
      //  fire.read();
      //}
      //renderImage.
    }
    now = second();
    if (now - this.lastTransitionTimestamp > this.transitionInterval) {
      println("transition trigger");
      modeTransition();
      this.lastTransitionTimestamp = now;
    }
  }

  public void modeTransition() {
    mode = (mode+1) % 3;
  }

  private void printImagelist() {
    println("Current loaded images: ");
    for (PImage i : this.images) {
      print(i);
      println("   --  dimensions ("+i.width+", "+i.height+")");
    }
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
    switch (mode) {
    case 0:
      fireMode(); 
      break;
    case 1:
      imageBumpMode();
      break;
    case 2:
      waveMode();
      break;
    default:
      //fireMode();
      break;
    }
    updateBeat();
  }

  public void imageBumpMode() {
    int picAlpha = int(map(beat, 0, 100, 0, 255));

    parent.pushMatrix();
    translate(this.pos.x, this.pos.y);
    scale(this.scale);
    parent.imageMode(CENTER);
    tint(255, 255);

    image(this.renderImage, 0, 0, this.parent.width, this.parent.height);
    // image(fire, 0, 0, this.parent.width, this.parent.height);

    parent.popMatrix();
    pushMatrix();
    translate(parent.width/2, parent.height/2);
    blendMode(BLEND);
    tint(255, 0, 0, picAlpha);
    image(altImage, 0, 0, parent.width, parent.height);
    popMatrix();
  }

  public void fireMode() {
    fireEffect.draw();
  }

  public void waveMode() {
    waveEffect.draw();
  }
  public void dispose() {
    println("running imagemanager dispose");
    fireEffect.dispose();
    this.images.clear(); 
    this.renderImage = null;
  }

  public void beat() {
    this.beat = 100;
  }

  public void updateBeat() {
    this.beat = (this.beat - 5 >= 0)? this.beat - 5 : 0;
  }

  public void addImage(PImage im) {
    this.images.add(im);
    im.resize(renderImage.width, renderImage.height);
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