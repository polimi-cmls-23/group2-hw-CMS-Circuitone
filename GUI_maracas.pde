import controlP5.*;
ControlP5 cP5;
  PImage img;
  PImage img_rotated;
  PImage img_background;
  PImage img_sand;
  float altezza = -50;
  float knobValue; 
  Knob myKnobA; // toglierlo, lo farà il potenziometro
  Knob grainKnob;
  Knob volumeKnob;
  
void setup (){
  size (1400,900);
  img = loadImage("C:/Users/Utente/Maracas/Maracas.png");
  img_rotated = loadImage("C:/Users/Utente/Maracas/Maracas_rotated.png");
  img_sand = loadImage("C:/Users/Utente/Maracas/Sand.png");
  img_background = loadImage("C:/Users/Utente/Maracas/MaracaSpace_buco.png");
  cP5 = new ControlP5(this);
  grainKnob = cP5.addKnob("Number of grains", 3000, 10000, 10000, 1167, 500, 130);
  grainKnob.setColorForeground(color(11, 79, 108))
            .setColorBackground(color(253,192,69))
            .setColorActive(color(11, 79, 108))
            .setColorValueLabel(color(253,192,69))
            .setLabelVisible(false);
  volumeKnob = cP5.addKnob("Master Volume", 0, 1, 0.5, 1167, 720, 130);
  volumeKnob.setColorForeground(color(11, 79, 108))
            .setColorBackground(color(253,192,69))
            .setColorActive(color(11, 79, 108))
            .setColorValueLabel(color(11, 79, 108))
            .setLabelVisible(false);
  myKnobA = cP5.addKnob("Knob A", 100, 200, 128, 100, 160, 40); // toglierlo, lo farà il potenziometro

  
}

void draw (){
    background(80,24,13);
    img.resize (150, 150);
    img_rotated.resize (150, 150);
    img_sand.resize (400, 400);
    image(img_sand, 1100, int(altezza)); // range y da 20 a -50
    image(img_background, 0, 0);
    if(mouseX > 412 && mouseX < 986 && mouseY < 683 && mouseY > 236) {
    noCursor();
      if(mouseX < 650) {
          image(img_rotated, mouseX - 19, mouseY - 18);
      }
      else {
          image(img, mouseX - 19, mouseY - 18);
      }
    // rotated maracas image 
  }
  else {
    cursor(ARROW);
  }
  knobValue = myKnobA.getValue(); // toglierlo, lo farà il potenziometro
  noFill();
  rect(100, 400, 100, 400, 20);
  fill(253,192,69);
  float v = (knobValue - 100) / 100;
  knobValue = v * 400;
  if(knobValue > 30) {
    rect(100, 800, 100, -knobValue, 20);
  }
  else {
    rect(100, 800, 100, -30, 20);
  }
     text("NUMBER OF\nGRAINS", 1232, 655);
     textSize(17);
     textAlign(CENTER);
     text("MASTER VOLUME", 1232, 880);
     textSize(17);
     textAlign(CENTER);
     text("ENPHASIS", 150, 850);
     textSize(17);
     textAlign(CENTER);
}

 void controlEvent(ControlEvent theEvent) {
   if (theEvent.isController()) {
      if(theEvent.getController().getName()=="Number of grains") {
           altezza = map(theEvent.getController().getValue(), 3000, 10000, 50, -50);
       }
   }

  
}
    

  
