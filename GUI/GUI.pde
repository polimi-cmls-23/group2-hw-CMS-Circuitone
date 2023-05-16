import processing.sound.*;

SoundFile soundFile; // 

void setup() {
  size(800, 600); //

  
  soundFile = new SoundFile(this, "audio.wav");
  

  soundFile.play();
}

void draw() {
  background(0); 


  if (soundFile.isLoaded()) {

    float[] waveform = soundFile.getPeaks(width);
  

    stroke(255); 
    noFill();
    beginShape();
    for (int i = 0; i < waveform.length; i++) {
      float x = map(i, 0, waveform.length, 0, width);
      float y = map(waveform[i], -1, 1, height, 0);
      vertex(x, y);
    }
    endShape();
  }
}
