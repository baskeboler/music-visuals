import g4p_controls.*;



import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
BeatDetect beat;
AudioPlayer player;
G4P g4p;
boolean exitRequested;
PImage image;
int imageScale; // 0 to 25
int tintAlpha; // 0 to 10
void setup() {
  size(640, 480, FX2D); 
  //fullScreen(FX2D);
  createGUI();
  exitRequested = false;
  PSurface s = surface;
  s.setResizable(true);
  minim = new Minim(this);
  noLoop();
  selectInput("Select a song", "fileSelected");
  imageScale = 0;
  tintAlpha = 0;
  beat = new BeatDetect();
  beat.setSensitivity(200);
  beat.detectMode(BeatDetect.FREQ_ENERGY);
  image = loadImage("picture.jpg");
  println("picture loaded");

  imageMode(CENTER);
}

void fileSelected(File f) {
  if (f == null) {
    println("user cancelled");
  } else {
    if (player != null && player.isPlaying()) {
      player.close();
    }
    player = minim.loadFile(f.getAbsolutePath(), 1024);
    println("sound file loaded");
    loop();
    //redraw();
    player.play();
    //beat.
  }
}

void draw() {
  if (player == null) return;
  if (exitRequested) {

    player.close();
    minim.stop();
    exit();
  }
  background(0);
  beat.detect(player.mix);
  if (beat.isKick()) {
    imageScale = 25;
  } else if (imageScale > 0) {
    imageScale--;
  }
  if (beat.isSnare()) {
    tintAlpha = 10;
  } else if (tintAlpha > 0) {
    tintAlpha--;
  }
  float scale = map(imageScale, 0, 25, 1, 1.5f);
  int alpha = (int)map(tintAlpha, 0, 10, 0, 255); 
  pushMatrix();
  //float a = map(
  if (tintAlpha > 0) {
    tint( 255, 0, 0, alpha);
  } else {
    noTint();
  }
  translate(width/2, height/2);
  scale(scale);
  image(image, 0, 0, width, height);
  //getSurface().set
  popMatrix();
}

void onSelectImage(File f) {
  if (f != null) {
    image = loadImage(f.getAbsolutePath());
    player.play();
    loop();
  } else {
    println("Error leyendo la imagen");
  }
}

void keyPressed() {
 if (key == ESC) {
    exitRequested = true; 
 }
}