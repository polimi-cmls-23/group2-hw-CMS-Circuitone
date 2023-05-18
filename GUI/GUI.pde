import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer audioPlayer;
FFT fft;

void setup() {
  size(800, 600);

  minim = new Minim(this); // Create a Minim object
  audioPlayer = minim.loadFile("test.wav"); // Load an audio file
  audioPlayer.play(); // Start playing the audio

  fft = new FFT(audioPlayer.bufferSize(), audioPlayer.sampleRate());
} // Create an FFT object

void draw() {
  background(0);
  
  // Analyze the audio
  fft.forward(audioPlayer.mix);

  // Calculate the width and height for the spectrogram area
  int spectrogramWidth = width / 3;
  int spectrogramHeight = height / 2;

  // Set the position of the spectrogram in the top right corner
  int spectrogramX = width - spectrogramWidth;
  int spectrogramY = 0;

  // Draw the spectrogram
  stroke(255, 0, 0); // Set stroke color to red
  strokeWeight(1); // Set stroke weight to 2
  noFill();
  beginShape();
  for (int i = 0; i < fft.specSize(); i++) {
    float x = map(i, 0, fft.specSize(), 0, spectrogramWidth);
    float y = map(fft.getBand(i), 0, 255, spectrogramHeight, 0);
    vertex(x + spectrogramX, y + spectrogramY);
  }
  endShape();
  
  // Draw the legend
  fill(255);
  textSize(16);
  textAlign(CENTER);
  text("Spectrum", spectrogramX + spectrogramWidth / 2, spectrogramY + spectrogramHeight + 20);
  
  // Calculate the width and height for the waveform area
  int waveformWidth = width / 3;
  int waveformHeight = height / 2;
  
  // Set the position of the waveform in the bottom right corner
  int waveformX = width - waveformWidth;
  int waveformY = height - waveformHeight;
  
  // Draw the waveform
  stroke(0, 255, 0); // Set stroke color to green
  strokeWeight(1); // Set stroke weight to 1
  noFill();
  beginShape();
  for (int i = 0; i < audioPlayer.bufferSize() - 1; i++) {
    float x = map(i, 0, audioPlayer.bufferSize(), 0, waveformWidth);
    float y = map(audioPlayer.left.get(i), -1, 1, waveformY, waveformY + waveformHeight);
    vertex(x + waveformX, y);
  }
  endShape();
  
  // Draw the legend
  fill(255);
  textSize(16);
  textAlign(CENTER);
  text("Waveform", waveformX + waveformWidth / 2,  height- 20);
  
  
}


void stop() {
  audioPlayer.close();
  minim.stop();

  super.stop();
}
