public class ImageManager { //<>// //<>//
  private ArrayList<PImage> images = new ArrayList();
  private int updateInterval = 1;
  private int transitionInterval = 60;
  private Movie fire;
  private PImage mainImage;
  private PImage altImage;
  private PImage renderImage;
  private PApplet parent;
  private int lastTransitionTimestamp;
  private int lastUpdateTimestamp;
  private PMatrix2D matrix;
  private float scale;
  private PVector pos;
  private boolean matrixChanged;
  private PImage alphaMask;
  private boolean enableAlphaMask;
  int beat = 0;

  public ImageManager(PApplet parent, String imagePath) {
    this.parent = parent;
    println("Creating imagemanager");

    this.fire = new Movie(parent, "fire.mp4");
    this.fire.loop();
    this.fire.volume(0);
    this.mainImage = parent.loadImage(imagePath);
    println("main image loaded");
    this.renderImage = this.mainImage.copy();
    println("render image created");
    //parent.applyMatrix(
    this.matrix = new PMatrix2D();
    this.matrix.reset();
    println("imagemanager matrix initialized");
    this.init();
  }

  private void init() {
    // renderImage.init(,,, )
    this.lastTransitionTimestamp = second();
    this.lastUpdateTimestamp = millis();
    this.scale = 1f;
    this.pos = new PVector(parent.width/2, parent.height/2);
    alphaMask = loadImage("alphamask.png");
    //alphaMask.filter(GRAY);
    alphaMask.resize(renderImage.width, renderImage.height);
    //renderImage.mask(alphaMask);
    println("alpha mask loaded and resized");
  }

  private void update() {
    int now = millis();
    if (now - this.lastUpdateTimestamp > this.updateInterval) {
      // update code
      this.setScale(map(beat, 0, 100, 1, 3));
      this.setPos(parent.width/2, parent.height/2);
      this.lastUpdateTimestamp = now;
      if (this.matrixChanged) {
        updateMatrix();
      }
      if (fire.available()) {
       fire.read(); 
      }
      //renderImage.
    }
  }

  private void updateMatrix() {
    //    println("updating imagemanager matrix");
    this.matrix.reset();
    this.matrix.translate(this.pos.x, this.pos.y);
    this.matrix.scale(this.scale);
    this.matrixChanged = false;
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
    matrixChanged = true;
  }

  public void setScale(float x) {
    this.scale = x;
    matrixChanged = true;
  }

  public void draw() {
    this.update();
    fireMode(); 
    updateBeat();
  }

  public void imageBumpMode() {
    int picAlpha = int(map(beat, 0, 100, 0, 255));

    parent.pushMatrix();
    parent.applyMatrix(this.matrix);
    parent.imageMode(CENTER);
    tint(255, 255);

    image(this.renderImage, 0, 0, this.parent.width, this.parent.height);
    // image(fire, 0, 0, this.parent.width, this.parent.height);

    parent.popMatrix();
    pushMatrix();
    translate(parent.width/2, parent.height/2);
    blendMode(BLEND);
    tint(255, 0, 0, picAlpha);
    image(alphaMask, 0, 0, parent.width, parent.height);
    popMatrix();
  }

  public void fireMode() {
    int picAlpha = int(map(beat, 0, 100, 0, 255));
    tint(255, 255);
    image(fire, 0, 0, parent.width, parent.height);
    blendMode(BLEND);
    tint(255, 0, 0, picAlpha);
    image(alphaMask, 0, 0, parent.width, parent.height);
  }

  public void dispose() {
    println("running imagemanager dispose");
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
    alphaMask = im;
  }

  public void movieEvent(Movie m) {
    m.read();
  }
}