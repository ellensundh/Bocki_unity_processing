import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.awt.*;

OscP5 oscP5;

NetAddress myBroadcastLocation; 

Panel panel1 = new Panel();

TextField textField = new TextField("/eventtest", 16);
TextField textField2 = new TextField("3", 16);
TextField porttf = new TextField("12000", 5);
float currentValue = 0;
float counter = 2;
float toggle = 0;
  
void setup() {
  size(400,140);
  frameRate(25);
  
  oscP5 = new OscP5(this,12000);
  myBroadcastLocation = new NetAddress("127.0.0.1",8000);
  
 
  add(panel1);
  add(textField);
  add(textField2);
  
  panel1.setLayout(new BorderLayout()); 
  panel1.setBounds(150,100,50,50); 
   
} 

boolean overButton(int x, int y, int width, int height) 
{
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}



void draw() {
  background(0);
  
  fill(33, 33,33);
  rect(140, 40, 115, 35);
 
  PFont font = loadFont("Helvetica-Bold-18.vlw"); 
  textFont(font,18);
  fill(255, 255,255);
  text("Send event",150, 50, 200, 70); 
  
  textFont(font,10);
  fill(255, 255,255);
  text("Dispatches event to 127.0.0.1 port 8000 Send counter value: " + counter,100, 100, 200, 70); 
  sendCounter();
}


void mousePressed() {
   if( overButton(140, 40, 115, 35)) {
     sendEvent(textField.getText(),textField2.getText());
   }
}

void sendEvent(String eventName, String eventData) {
  OscMessage myOscMessage = new OscMessage("/eventTest");  
  myOscMessage.add(eventData);
  oscP5.send(myOscMessage, myBroadcastLocation);
}

void sendCounter() {
  OscMessage myOscMessage = new OscMessage("/counterTest");  
  
  if(counter == 50) {
    toggle = 1;
  } else if(counter == 2) {
    toggle = 0;
  }
  
  if(toggle == 0) {
    counter++;
  } else if(toggle == 1) {
    counter--;
  }
  println(counter);
  myOscMessage.add(counter);
  oscP5.send(myOscMessage, myBroadcastLocation);
}


void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  theOscMessage.print();
}


