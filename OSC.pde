
float padX;
float padY;

int nrFingers = 0;

//vars to count the number of fingers. 
//the numbers of fingers = visuzaliation mode
int counter=0;
int[] count = { 0,0,0,0 };

float rotaX =0.0;

//RECEIVING DATA FROM TOUCH OSC (tablet)
void oscEvent(OscMessage OscPad) {

if(tablet) {
  
counter=0;

//rotation, orientation
//Finger 1
if(OscPad.checkAddrPattern("/1/xy/1")==true) {
padX = OscPad.get(0).floatValue();
padY = OscPad.get(1).floatValue();   
padY=map(padY,0,1,2.8,-2.8);

padX=map(padX,0,1,0.3,-0.3);
rot+=(padY-rot)*0.08; 
rotaX+=(padX-rotaX)*0.08;
count[0]=0;

}

//Finger2
if(OscPad.checkAddrPattern("/1/xy/2")==true) {
 count[1]=0;
}


//finger3
if(OscPad.checkAddrPattern("/1/xy/3")==true) {
  
  count[2]=0;

}


//println("total "+nrFingers);
  
//println(nrFingers);
//mode=nrFingers;

//velocity fader
if(OscPad.checkAddrPattern("/1/fader2")==true) {
  
 float val=OscPad.get(0).floatValue();
speed=int(map(val,0,1,1,10)); 
  
};

//GUI on/off
if(OscPad.checkAddrPattern("/1/display")==true){
 float gui = OscPad.get(0).floatValue();
  if(gui>0)display=!display;
  

}

}
}
