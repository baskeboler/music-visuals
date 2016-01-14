class VideoEffect implements Effect {
  private ImageManager parent;
  private Movie movie;
  private PImage bumperImage;
  private float rotate = 0;
  
  public VideoEffect(final ImageManager parent, String videoPath) {
    this.parent = parent;
    movie = new Movie(parent.getParent(), videoPath);
    movie.loop();
    movie.volume(0);

    bumperImage = parent.altImage;
    PApplet.println("VideoEffect loaded with " + videoPath);
  }
  
  void dispose() {
   movie.dispose(); 
  }
  
  void activate() {
    movie.loop();
  }
  
  void deactivate() {
    movie.pause();
  }
  
  void draw() {
    final PApplet app = parent.getParent();
    app.imageMode(PConstants.CENTER);
    app.pushMatrix();
    app.translate(app.width / 2, app.height / 2);
    final int picAlpha = (int) PApplet.map(parent.beat, 0, 100, 0, 128);
    app.tint(255, 255);
    if (movie.available()) {
      movie.read();
    }
    app.image(movie, 0, 0, app.width, app.height);
    app.scale(parent.getScale());
    app.blendMode(PConstants.BLEND);
    app.tint(255, picAlpha);
    app.rotate(rotate += 0.01);
    app.image(bumperImage, 0, 0); // , parent.width, parent.height);
    app.popMatrix();
  }
}