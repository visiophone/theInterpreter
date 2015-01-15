/*
The Interpreter
http://visiophone-lab.com/wp/?portfolio=the-interpreter
Rodrigo Carvalho
// is you want to control via mouse+GUI put the var "tablet" false,
// osc tab is waiting OSC from an external controler (i used a tablet with touchOSC)
// and is also sending out some values form the body silluete

Needs toxic, peasyCam, oscP5 and controlP5 libs
check processing.org to find the libraries. 
*/

//////////////////////////////////
 //geometrical stuff
import toxi.geom.*;
//3d cam
import peasy.*;
// Camera
  PeasyCam cam;
//video stuff  
import processing.video.*;
Movie movie;

//osc
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress sendPort;

//var that store info from motiondata "silluete"
String[] lines;
int index = 0;
Vec2D[][] body;

// 0.centro / 1.T / 2.R / 3.B / 4.L / 5.corn1 / 6.corn2 / 7.corn3 / 8.corn4
Vec3D[] centroids;


// controler for the timeline. It start with 600 to sync with the video
int time=600;

//Class that makes the visualizations of each mode
Viz [] viz;

float rota;

// conter to reset the modes to zero
int countReset=0;
boolean reset=false;

//bool that define if the interaction is with keyboard+mouse ou tablet
boolean tablet =false;

void setup(){
 //size(1024,768,P3D); 
 size(displayWidth, displayHeight,P3D);
 
 //new window for the controls GUI
 cf = addControlFrame("CONTROL CENTER", 250,400);
   //START OSC
  oscP5 = new OscP5(this,8000);
  sendPort = new NetAddress("127.0.0.1",4000);
  //START MOVIE
  movie = new Movie(this, "SUNNY1b.mov");
  movie.loop();
  
  //camera Starting Def
  cam = new PeasyCam(this, 1600);
  cam.setResetOnDoubleClick(false); 
  cam.lookAt(0.0, 50.0, -1175);
  //parsing textFile
  initData();
  //Iniciating VIZZ
   viz= new Viz[50];
  
    for(int i=0;i<viz.length;i++){
      viz[i]= new Viz(i); 
     
    }
  
  mode=0;
  
   noCursor();
}


void draw(){
 
 
 background(0);
 updateData(); 
 


//////  
// WHERE THE ACTION HAPPENS

pushMatrix();

translate(-(width/2), -(height/2)+100,0);

//if mode ZERO
if(mode==0){
//center scene  
pushMatrix();
translate(0,0,150);
pushMatrix();
translate(0,0,-250);

stroke(220);
noFill();

//draw rectangles
for(int i=3;i<50;i=i+20){
beginShape();
vertex(viz[i].centroids[5].x,viz[i].centroids[5].y, viz[i].centroids[5].z);
vertex(viz[i].centroids[6].x,viz[i].centroids[6].y,viz[i].centroids[5].z);
vertex(viz[i].centroids[7].x,viz[i].centroids[7].y, viz[i].centroids[5].z);
vertex(viz[i].centroids[8].x,viz[i].centroids[8].y,viz[i].centroids[5].z);
endShape(CLOSE);
}
//draw silhuete
for (int k=1; k<38; k++)
  {
      
    if (body[time][k]!=null) { 
      
      float x=map(body[time][k].x, 0, 640, 0, width);
      float y=map(body[time][k].y, 0, 480, 0, height);      

      stroke(255);
      fill(255);
      ellipse(x, y, 5, 5);
      
    }   
  }

  popMatrix();
  

popMatrix();
}
// [end mode 0]

//////

 //UPDATING POSITIONS
 //loocking for the noise error. (when the data is null and all the values are 0,,0,0,0)
  if(centroids[0].x!=0.0&&centroids[0].y!=0)
{
 viz[0].update(centroids[0],centroids[1],centroids[2],centroids[3],centroids[4],centroids[5],centroids[6],centroids[7],centroids[8]);
 
 // println("noise detect");
}
 
//UPDATING CLASS POSITIONS. IT REPLICATIONS POSITIONS OF [0]
for(int i=1;i<viz.length;i++){
 if(i>2 ) viz[i].display();
 if(i!=0 ) viz[i].update(viz[i-1].centroids[0],viz[i-1].centroids[1],viz[i-1].centroids[2],viz[i-1].centroids[3],viz[i-1].centroids[4], viz[i-1].centroids[5], viz[i-1].centroids[6], viz[i-1].centroids[7], viz[i-1].centroids[8]);
}
popMatrix();
 

 /// NOT AFECTED BY THE PEASY CAM
 // DISPLAYS
cam.beginHUD(); 

//SYNC VIDEO WITH DATA
float movPos=0.00f; 
movPos =((time-450)/50.0);
movPos = int(movPos*100);
movPos = movPos/100.0;
  
//DISPLAY VIDEO
movie.speed(speed);
if(display)image(movie, width-176, 0, 176, 100);

// DATA TIME IS DEPENDENT ON THE VIDEO TIME. MAP THE VIDEODURATION TO DATA TIMELINE
time=int(map(movie.time(),0,movie.duration(),950,lines.length-1));

if(display){
//DrawRect
noFill();
stroke(255);
rect(width-176,0,176,100);

//Draw silhuete
pushMatrix();
translate(width-352,0);
fill(0);
stroke(255);
rect(0,0,176,100);

drawBody(176,100);
//viz[0].display();
// VIZZ FEEDBACK OVER THE VIDEO
viz[0].tumb();

popMatrix();

// loopTimeline
drawTimeline();

}

// GENERAL white Frame
noFill();
stroke(255);
//rect(0,0,width,height);

cam.endHUD(); 

 
if(keyPressed){
  
 if(key=='0') mode=0; 
 if(key=='1') mode=1; 
 if(key=='2') mode=2; 
 if(key=='3') mode=3; 
 
 if(key=='a') println(time);
 
 if(key=='r') reset=true;
  
  
}

//COUNTING NR OF FINGERS OVER THE SCREEN
// only if tablet=true;
if(tablet){

for(int i=0;i<3;i++){
  if(count[i]<20){count[i]++;nrFingers++;}  
}

//println(counter);
if(nrFingers>0){mode=nrFingers; countReset=0;}
//println(nrFingers);

//only rotate if there are fingers on the screen
if(nrFingers>0)cam.setRotations(rotaX,rot,0);

//reset to mode ZERO
if(nrFingers==0 && reset==false && mode!=0) countReset++;
if (countReset>30 && nrFingers==0) reset=true;;
//println(countReset);

// some calcs to compute nr of fingers
if(counter<20){counter++;nrFingers=1;}
nrFingers=0;
if(counter>=20){nrFingers=0;}

}

//reset mode
if(reset){
  mode=0;
  cam.setRotations(0,-0.2,0);
  cam.setDistance(1600);
  reset=false;
  speed=1;
  display=true;
}

//println(cam.getDistance());

}


//VIDEO STUFF
void movieEvent(Movie m) {
  m.read();
}
