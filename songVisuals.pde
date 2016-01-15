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
AudioInput in;
ImageManager imageManager;
Ticker ticker;

boolean exitRequested;

void setup() {
  //size(800, 600, P3D);
  //size(640, 480, FX2D); 
  size(300, 200, P3D);
  //  frameRate(40);

  //  fullScreen(P3D);
background(0);
  //images = new ArrayList();
  //createGUI();
  //configWindow.setVisible(false);
  exitRequested = false;
  //PSurface s = surface;
  surface.setResizable(true);
  // s.setVisible(false);
  minim = new Minim(this);
  minim.debugOn();

  //Mixer.Info mInfo = AudioSystem.getMixerInfo()[2];
  //mixer = AudioSystem.getMixer(mInfo);
  //minim.setInputMixer(mixer);
  in = minim.getLineIn(Minim.MONO);
  //minim.getLineOut().close();
  //minim.getLineIn().
  // noLoop();
  //fire.speed(4);
  //selectInput("Select a song", "fileSelected");
  beat = new BeatDetect();
  // beat.setSensitivity(200);
  beat.detectMode(BeatDetect.SOUND_ENERGY);
//  AudioBuffer 
  //image = loadImage("picture.jpg");
  //images.add(image);
  //vid.loop();
  imageManager = new ImageManager(this, "picture.jpg");
  println("imageManager loaded");
  ticker = new Ticker(this, "PIZZA - $200 .... EMPANADAS - $45 .... CERVEZA - $120 .... SEXO ORAL - $500");
  //imageMode(CENTER);
  smooth();
}

//void fileSelected(File f) {
//  if (f == null) {
//    println("user cancelled");
//  } else {
//    if (player != null && player.isPlaying()) {
//      player.close();
//    }
//    player = minim.loadFile(f.getAbsolutePath(), 1024);
//    println("sound file loaded");
//    loop();
//    surface.setVisible(true);
//    //redraw();
//    //vid = new Movie(this, "video.wmv");
//    player.loop();
//    //vid.loop();
//    //beat.
//  }
//}

void draw() {
  //if (player == null) return;
  if (exitRequested) {
    configWindow.dispose();
    //player.close();
    imageManager.dispose();
    configWindow.close();
    minim.stop();
    minim.dispose();
   // exit();
  }
//  background(0);
  //beat.detect(player.mix);
  beat.detect(in.mix);  
  if (beat.isOnset()) {
    imageManager.beat();
  }
  pushStyle();
  imageManager.draw();
  popStyle();
  ticker.draw();
}




void keyPressed() {
  switch (key) {
  case ESC:
    println("ESC key pressed!");
    exitRequested = true;
    break;

  case ENTER:
    //mode = (mode+1)%2;
    imageManager.modeTransition();
    break;
  default:
    break;
  }
}