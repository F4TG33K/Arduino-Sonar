import processing.serial.*;                          // imports library for serial communication
import java.awt.event.KeyEvent;                      // imports library for reading the data from the serial port
import java.io.IOException.*;                          // imports library for handling exceptions
import processing.sound.*;                           // imports library for playing sound

SoundFile file;                                      // defines Object SoundFile
Serial myPort;                                       // defines Object Serial

String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
int COM =0;
PFont orcFont;
Table table;
Boolean ShowTrace=true;

void MsgBox(String Msg,String Titel){
javax.swing.JOptionPane.showMessageDialog ( null, Msg, Titel, javax.swing.JOptionPane.INFORMATION_MESSAGE  );
}

void StoreCoord(float X, float Y) {
 TableRow newRow = table.addRow();
  newRow.setFloat("X", X);
  newRow.setFloat("Y", Y);
}

void setup() {
  while (COM == 0) {
  try {
    myPort = new Serial(this,Serial.list()[0], 115200);   // starts the serial communication
    COM =1;
  } catch (Exception e) {
    e.printStackTrace();
    MsgBox("It looks like your Arduino is not connected to your computer !", "ERROR");
    }
  }
 size (1280, 768);                                   // defines the window's size
 smooth();                                           // makes the shapes more beautiful
 file = new SoundFile(this, "son.mp3");              // pick an audio file in the "data" file of your project
 file.loop();                                      // starts the playback of the soundfile to loop.
 
 table = new Table();
 table.addColumn("X");
 table.addColumn("Y");
 
 myPort.bufferUntil('.');                            // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
 orcFont = loadFont("Moon-Light-50.vlw");         // set the font up
 background(149, 165, 166);                          // set the background color
}

void draw() {
  //fill(26, 188, 156);                          
  textFont(orcFont);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,5); 
  rect(0, 0, width, height-height*0.065);           // draw a special space for the text
  fill(26, 188, 156); // green color
  // calls the functions for drawing the radar
  drawObject();
  drawRadar(); 
  drawLine();
  
  drawText();
}

void serialEvent (Serial myPort) {                 // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() {
  pushMatrix();
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(52, 152, 219);
  // draws the arc lines
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  // draws the angle lines
  strokeWeight(2);
  line(-width/2.137,0,width/2.137,0);
  strokeWeight(2);
  line(0,0,(-width/2.137)*cos(radians(30)),(-width/2.137)*sin(radians(30)));
  line(0,0,(-width/2.137)*cos(radians(60)),(-width/2.137)*sin(radians(60)));
  line(0,0,(-width/2.137)*cos(radians(90)),(-width/2.137)*sin(radians(90)));
  line(0,0,(-width/2.137)*cos(radians(120)),(-width/2.137)*sin(radians(120)));
  line(0,0,(-width/2.137)*cos(radians(150)),(-width/2.137)*sin(radians(150)));
  line((-width/2.137)*cos(radians(30)),0,width/2.137,0);
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(2);
  stroke(236, 240, 241);
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  line((height-height*0.219)*cos(radians(iAngle)),-(height-height*0.219)*sin(radians(iAngle)),(height-height*0.20)*cos(radians(iAngle)),-(height-height*0.20)*sin(radians(iAngle))); // draws the line according to the angle
  strokeWeight(5);
  //point((height-height*0.2125)*cos(radians(iAngle)),-(height-height*0.2125)*sin(radians(iAngle)));
  if (ShowTrace ==  true) {
  for (TableRow row : table.rows()) {
    stroke(192, 57, 43);
  strokeWeight(8);
  smooth();
  point(row.getFloat("X"),row.getFloat("Y"));
  }
  }
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  // red color (FLAT DESIGN)192, 57, 43
  pixsDistance = iDistance*((height-height*0.1666)*0.01885); // covers the distance from the sensor from cm to pixels
  // limiting the range to 40 cms
  if(iDistance<41 && iDistance != 0){
    // draws the object according to the angle and the distance
  //line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(height-height*0.22)*cos(radians(iAngle)),-(height-height*0.22)*sin(radians(iAngle)));
  //point(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
  stroke(231, 76, 60);
  strokeWeight(20);
  point(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
  //strokeWeight(1);
  //stroke(241, 196, 15); 
  //line(pixsDistance*cos(radians(iAngle))-15, -pixsDistance*sin(radians(iAngle)), pixsDistance*cos(radians(iAngle))+15, -pixsDistance*sin(radians(iAngle))); 
 //line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle))-15, pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle))+15);
  
  
  StoreCoord((pixsDistance*cos(radians(iAngle))),(-pixsDistance*sin(radians(iAngle))));
  
  }
  popMatrix();
}
void drawText() { // draws the texts on the screen
  
  pushMatrix();
  if(iDistance>40 || iDistance == 0) {
  noObject = "NON";
  }
  else {
  noObject = "OUI";
  }
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(26, 188, 156);
  textSize(25);
  
  text("10cm",width-width*0.3854,height-height*0.0833);
  text("20cm",width-width*0.281,height-height*0.0833);
  text("30cm",width-width*0.177,height-height*0.0833);
  text("40cm",width-width*0.0729,height-height*0.0833);
  textSize(40);
  text("Signal : " + noObject, width-width*0.9, height-height*0.015); //0.875
  text("Angle : " + iAngle +" °", width-width*0.57, height-height*0.015);
  text("Dist. : ", width-width*0.26, height-height*0.015);
  if(iDistance<41 && iDistance !=0) {
  text("        " + iDistance +" cm", width-width*0.21, height-height*0.015);
  }
  else {
  text("        ?", width-width*0.21, height-height*0.015);
  }
  textSize(25);
  fill(26, 188, 156);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}

void mouseReleased() {
  if (ShowTrace == true) {
    ShowTrace = false;
    }
    else {
      ShowTrace = true;
    }
}