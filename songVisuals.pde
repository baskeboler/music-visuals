import processing.video.*;
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
ImageManager imageManager;

boolean exitRequested;
int imageScale; // 0 to 25
int tintAlpha; // 0 to 10

void setup() {
  //size(800, 600, P3D);
  //size(640, 480, P3D); 
  size(400, 300, FX2D);
  //fullScreen(FX2D);
  //images = new ArrayList();
  createGUI();
  exitRequested = false;
  PSurface s = surface;
  s.setResizable(true);
  minim = new Minim(this);
  minim.debugOn();
  noLoop();
  selectInput("Select a song", "fileSelected");
  imageScale = 0;
  tintAlpha = 0;
  beat = new BeatDetect();
  // beat.setSensitivity(200);
  beat.detectMode(BeatDetect.SOUND_ENERGY);
  //image = loadImage("picture.jpg");
  //images.add(image);
  //vid.loop();
  imageManager = new ImageManager(this, "picture.jpg");
  println("imageManager loaded");

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
    //vid = new Movie(this, "video.wmv");
    player.play();
    //vid.loop();
    //beat.
  }
}

void draw() {
  if (player == null) return;
  if (exitRequested) {

    player.close();
    minim.stop();
    minim.dispose();
    exit();
  }
  background(0);
  beat.detect(player.mix);
  //if (beat.isOnset()) {
  //  imageScale = 25;
  //} else if (imageScale > 0) {
  //  imageScale--;
  //}
  //if (beat.isOnset()) {
  //  tintAlpha = 10;
  //} else if (tintAlpha > 0) {
  //  tintAlpha--;
  //}
  if (beat.isOnset()) {
    imageManager.beat();
  }
  //float scale = map(imageScale, 0, 25, 1, 1.5f);
  //int alpha = (int)map(tintAlpha, 0, 10, 0, 255); 
  //pushMatrix();
  //float a = map(
  //if (tintAlpha > 0) {
  //  tint( 255, 0, 0, alpha);
  //} else {
  //  noTint();
  //}
  //translate(width/2, height/2);
  //scale(scale);
  //if (vid!= null && vid.available()) {
  //  vid.read();
  //}
  //if (vid!=null && vid.isLoaded())
  //  image(vid, 0, 0, vid.width, vid.height);
  //getSurface().set
  //image(image, 0, 0, width, height);
  imageManager.draw();
//  popMatrix();
}

void redraw() {
  println("running redraw");  
}

void onImageFileSelected(File f) {
  if (f != null) {
    PImage localImage = loadImage(f.getAbsolutePath());
    if (localImage != null) {
      println("Image was loaded successfully");
      //images.add(localImage);
      //printImagelist();
    } else {
      println("Unable to load {{" + f.getName() + "}} as an image");
    }
  } else {
    println("Error leyendo la imagen");
  }
}



void keyPressed() {
  if (key == ESC) {
    println("ESC key pressed!");
    exitRequested = true;
  }
}