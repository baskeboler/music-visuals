import processing.video.*;
import g4p_controls.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// need to import this so we can use Mixer and Mixer.Info objects
//import javax.sound.sampled.*;

Minim minim;
BeatDetect beat;
//AudioPlayer player;
AudioInput in;
ImageManager imageManager;

boolean exitRequested;
int imageScale; // 0 to 25
int tintAlpha; // 0 to 10
//Mixer mixer;
int mode = 0;

void setup() {
  //size(800, 600, P3D);
  size(640, 480, P3D); 
  //size(300, 200, P3D);
  //  frameRate(40);

  //  fullScreen(P3D);
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

  //imageMode(CENTER);
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
  imageManager.draw();
}


void onImageFileSelected(File f) {
  if (f != null) {
    PImage localImage = loadImage(f.getAbsolutePath());
    if (localImage != null) {
      println("Image was loaded successfully");
      //images.add(localImage);
      //printImagelist();
      imageManager.addImage(localImage);
    } else {
      println("Unable to load {{" + f.getName() + "}} as an image");
    }
  } else {
    println("Error leyendo la imagen");
  }
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