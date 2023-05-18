import oscP5.*;
import netP5.*;

OscP5 oscP5;
ArrayList<Float> audioData = new ArrayList<>();

void setup() {
  size(400, 200);
  
  // Create an OSC object
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0);
  
  if (!audioData.isEmpty()) {
    // Visualize the audio data
    stroke(255);
    noFill();
    beginShape();
    for (int i = 0; i < audioData.size(); i++) {
      float x = map(i, 0, audioData.size(), 0, width);
      float y = map(audioData.get(i), -1, 1, height, 0);
      vertex(x, y);
    }
    endShape(); // Add this line to close the shape
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/audio")) {
    // Receive the audio data
    float audioFrame = msg.get(0).floatValue();
    audioData.add(audioFrame);
  }
}
