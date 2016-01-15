class Ticker { //<>// //<>// //<>// //<>//
  public final int TOTAL_STEPS = 500;
  int step = 0;
  PFont font;
  PApplet parent;
  boolean scrollOnTop = true; // if false, scrolls on bottom
  String text;
  PVector pos;
  public Ticker(PApplet parent, String text) { //<>//
    this.parent = parent; //<>//
    this.font = parent.loadFont("SubwayTicker-48.vlw");
    if (this.font != null) {
      PApplet.println("ticker font loaded");
    }
    this.text = text;
    this.pos = new PVector();
    this.pos.x = parent.width;
    this.pos.y = textAscent()+textDescent();
    this.pos.z = 0;
    parent.textFont(this.font);
    textSize(32);
    println(this.text);
    //this.fontWidth = this.font.getGlyph('A').width;
    println("textWidth for ticker is " + textWidth(this.text));
  }

  public void update() {
    this.pos.x = PApplet.map(this.step, 0, TOTAL_STEPS, parent.width, -1*parent.textWidth(this.text));

    this.pos.y = textAscent()+textDescent();
    this.step = (this.step+1)%TOTAL_STEPS;
  }

  public void draw() {
    this.update();
    //parent.smooth();
    //parent.rectMode(CORNER);
    //noFill();
    stroke(255, 0, 0, 255);
    //parent.textMode(MODEL);
    textAlign(LEFT);
    textSize(32);

    //parent.stroke(128);
    //println(pos);
    // parent.blendMode(ADD);
    //rect(0,0, parent.width, 100);
    //parent.fill(255, 0, 0, 255);  
    //parent.tint(255);
    fill(255,255,255, 64);
    text(this.text, this.pos.x+5, this.pos.y+5);

    parent.fill(255, 0, 0, 255);
    text(this.text, this.pos.x, this.pos.y);
    //line(0, this.pos.y, parent.width, this.pos.y);
    //rect(0,0, parent.width, 100);
  }
}