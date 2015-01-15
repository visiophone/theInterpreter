import controlP5.*;
ControlP5 cp5;
// controls in separate window
import java.awt.Frame;
import java.awt.BorderLayout;
//frame for a new window
ControlFrame cf;
////////////////////////////////
// vars used in the GUI
 
int speed=1;  //playing Speed
boolean sendBody = true;
boolean sendCentroids = true;

int mode=2;

// vallue for the ZZ deep. 
int deep=-50;
boolean display=true;

float zoom=0.0;

float rot=0.0;

////////////////////////////////
ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

/////

public class ControlFrame extends PApplet {
  int w, h;
  int abc = 10;
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this); 
  // add a horizontal sliders, the value of this slider will be linked
   cp5.addFrameRate().setInterval(10).setPosition(0,height - 10);
 ///////////////////////////    
    
 // here create bottons and sliders, ..          
      cp5.addSlider("speed")
     .plugTo(parent,"speed")
     .setPosition(20 ,20)
     .setSize(150,15)
     .setRange(1, 10)    
     ;
  
  
   cp5.addSlider("rot")
    .plugTo(parent,"rot")
     .setPosition(20,60)
     .setSize(150,15)
     .setRange(-1.5, 1.5)
     ;
  
  
  
     
      cp5.addSlider("mode")
    .plugTo(parent,"mode")
     .setPosition(20,40)
     .setSize(150,15)
     .setRange(0, 4)
     ;
  
  /* 
        cp5.addSlider("deep")
    .plugTo(parent,"deep")
     .setPosition(20,60)
     .setSize(150,15)
     .setRange(-50, 50)
     ;
 */    
     cp5.addSlider("zoom")
    .plugTo(parent,"zoom")
     .setPosition(20,80)
     .setSize(150,15)
     .setRange(1000, 1500)
     ;
   
    cp5.addToggle("sendBody")
    .plugTo(parent,"sendBody")
     .setPosition(20,200)
     .setSize(30,15)
     ;
     
     cp5.addToggle("sendCentroids")
    .plugTo(parent,"sendCentroids")
     .setPosition(80,200)
     .setSize(30,15)
     ;

    cp5.addToggle("display")
    .plugTo(parent,"display")
     .setPosition(20,160)
     .setSize(30,15)
     ;

  
 ///////////////////////////    
     cp5.loadProperties(("hello.properties")); // file that save the properties
     
  }

  public void draw() {
      background(abc);
       
    if (keyPressed) {
    if (key == 's' ) cp5.saveProperties(("hello.properties"));
    if (key == 'l' ) cp5.loadProperties(("hello.properties"));
    
      }
      
 
  ////////////////////////////////////////////////    
      
  }
  
 /// class and stuff to open a ew   

  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  public ControlP5 control() {
    return cp5;
  }
  
  ControlP5 cp5;
  Object parent; 
}
