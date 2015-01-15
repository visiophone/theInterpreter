// noise cleaner
FloatList bNoiseX;
FloatList bNoiseY;

 float xTemp,yTemp;
//color blueish = color(3,160,255);
color blueish = color(255);

void initData() {

 bNoiseX = new FloatList();
 bNoiseY = new FloatList();
  //PARSING TEXT FILE
  lines = loadStrings("silluete1.txt");  
  //iniciating ptsBodyArray
  body = new Vec2D [lines.length][42];  
  // centroid = new Vec2D [lines.length] [10];
  centroids = new Vec3D [9];

  for (int i=0; i<lines.length; i++) {  
    //spliting each line by SPACES
    String[] split1 = split(lines[i], " ");
    //Deleting lines with /body tag. (Those lines are smaller

    if (split1.length>20) {
      // println(split1[0]+" "+split1[1]+" "+split1[2]+" "+split1[split1.length-3]+" "+split1[split1.length-6]); 
      // println(split1.length);

      int count=0;
      for (int f=2; f<split1.length-8; f=f+2) {
        //if(i==6513) println(float(split1[f])+" "+float(split1[f+1]));
        body[i][count]= new Vec2D(float(split1[f]), float(split1[f+1]));
        count++;
      }
      // println(count);
    }
  }


  for (int i=0; i<9; i++) {
    centroids[i]= new Vec3D (0.0, 0.0,0.0);
  }
}


// sendind OSC to max file
void updateData() {

  OscMessage myMessage3 = new OscMessage("/rotaY");
  //rotaY
  myMessage3.add(rot);
  oscP5.send(myMessage3, sendPort);
  
  OscMessage myMessage4 = new OscMessage("/rotaX");
  //rotaY
  myMessage4.add(rotaX);
  oscP5.send(myMessage4, sendPort);
  
    OscMessage myMessage5 = new OscMessage("/mode");
  //rotaY
  myMessage5.add(mode);
  oscP5.send(myMessage5, sendPort);
  
  
  //sending SILHUETE
  OscMessage myMessage = new OscMessage("/silluete");
  //draw silhuete
 
  for (int k=0; k<38; k++)
  {
    
    if (body[time][k]!=null) { 
      fill(100);
      noStroke();
      float x=map(body[time][k].x, 0, 640, 0, width);
      float y=map(body[time][k].y, 0, 480, 0, height);
      xTemp=x;
      yTemp=y;
      //ellipse(body[time][k].x,body[time][k].y,1,1); 
      //ellipse(x, y, 4, 4);

      myMessage.add(body[time][k].x+" "+body[time][k].y);
    }
    
    
    if (body[time][k]==null) {
      //println(time+" "+body[time][k]+" "+body[time-1][k]);
    //  body[time][k]= new Vec2D(xTemp,yTemp);
     //  body[time][k]= new Vec2D(body[time-1][k].x,body[time-1][k].y);
      //println(time+" "+body[time][k]+" "+body[time-1][k]);
    }
    
  }
  if(sendBody)oscP5.send(myMessage, sendPort);


  //////////////////////////////////////////////
  // Centroids Shape points
  
  // vars for the special poitns (leftmost, top, ..)
  float rDistX=0;
  float lDistX=0;
  float bDistY=0;
  float tDistY=0;
  float centerX=0;
  float centerY=0; 
  
  OscMessage myMessage2 = new OscMessage("/shapePoints"); 

  //CENTROID. CENTRO.  CENTROID[0]
  for (int k=0; k<38; k++)
  {
    if (body[time][k]!=null) {
      centerX+=body[time][k].x;
      centerY+=body[time][k].y;
    }
  }
  centroids[0].x=centerX/38;
  centroids[0].y=centerY/38;
  
  
  //REST OF THE POINTS
   for(int k=0;k<38;k++)
 {
   if(body[time][k]!=null){
     //TOP
     if((centroids[0].y-body[time][k].y)>tDistY){
      tDistY= centroids[0].y-body[time][k].y;
      centroids[1].x=body[time][k].x;
      centroids[1].y=body[time][k].y;    
     }     
     //RIGHT
     if((centroids[0].x-body[time][k].x)<rDistX){   
      rDistX= centroids[0].x-body[time][k].x;
      centroids[2].x=body[time][k].x;
      centroids[2].y=body[time][k].y;
     }     
     //BOTTOM
     
     if((centroids[0].y-body[time][k].y)<bDistY){
      bDistY= centroids[0].y-body[time][k].y;
      //centroids[3].x=body[time][k].x;
      //centroids[3].y=body[time][k].y;
      
      //falta fazer aqui a divisao por todos os bnoises
      bNoiseX.append(body[time][k].x);
      bNoiseY.append(body[time][k].y);
      //println(bNoise +" "+body[time][k].x);
      if(bNoiseX.size()>2)bNoiseX.remove(0);
      if(bNoiseY.size()>70)bNoiseY.remove(0);
      
     float bX=0.0;
     float bY=0.0;
     
      for (int i=0;i<bNoiseX.size();i++){

       bX+=bNoiseX.get(i);
       bY+=bNoiseY.get(i);
      // bY+=bNoise.get(i);
        //println(bX+ " "+i);
      }
      bX=bX/bNoiseX.size();
      bY=bY/bNoiseX.size();
      //println(centroids[3].x+" "+bX);
     // centroids[3].x=bX;
      //centroids[3].y=bY;
      centroids[3].x=body[time][k].x;
      centroids[3].y=body[time][k].y;
     }
     
     //LEFT
     if((centroids[0].x-body[time][k].x)>lDistX){
      lDistX= centroids[0].x-body[time][k].x;
      centroids[4].x=body[time][k].x;
      centroids[4].y=body[time][k].y;
   
     }    
   }
 }
 
 // Making the cornet of the embed rectangel. saving to centroid[]
 // 0.centro / 1.T / 2.R / 3.B / 4.L / 5.corn1 / 6.corn2 / 7.corn3 / 8.corn4
// corn1
 centroids[5].x=centroids[4].x;
 centroids[5].y=centroids[1].y;
 // corn2
 centroids[6].x=centroids[2].x;
 centroids[6].y=centroids[1].y;
 // corn3
 centroids[7].x=centroids[2].x;
 centroids[7].y=centroids[3].y;
 // corn4
 centroids[8].x=centroids[4].x;
 centroids[8].y=centroids[3].y;

  
 //ADDING POITNS TO MESSAGE
 myMessage2.add(centroids[0].x+" "+centroids[0].y);
 myMessage2.add(centroids[1].x+" "+centroids[1].y);
 myMessage2.add(centroids[2].x+" "+centroids[2].y);
 myMessage2.add(centroids[3].x+" "+centroids[3].y);
 myMessage2.add(centroids[4].x+" "+centroids[4].y);
 
if(sendCentroids)oscP5.send(myMessage2, sendPort);
 
 
 //Mapping values to the size of the screen
  for(int i=0;i<9;i++){
 centroids[i].x=map( centroids[i].x, 0,640,0,width);
 centroids[i].y=map( centroids[i].y, 0,480,0,height);
 }

}

//drawing BODY
void drawBody(int w, int h){
 
  //println(w);
float xx=0;
float yy=0; 
fill(255);
noStroke();

//rect
//ellipse(centroids[5].x,centroids[5].y,4,4);
noFill();
stroke(100);
beginShape();
vertex(map(viz[0].centroids[5].x, 0,width,0,w), map(viz[0].centroids[5].y, 0,height,0,h));
vertex(map(viz[0].centroids[6].x, 0,width,0,w), map(viz[0].centroids[6].y, 0,height,0,h));
vertex(map(viz[0].centroids[7].x, 0,width,0,w), map(viz[0].centroids[7].y, 0,height,0,h));
vertex(map(viz[0].centroids[8].x, 0,width,0,w), map(viz[0].centroids[8].y, 0,height,0,h));
endShape(CLOSE);



//centroid


for(int i=0;i<9;i++){
  
  xx=map(centroids[i].x, 0,width,0,w);
  yy=map(centroids[i].y, 0,height,0,h);
  
  if(i<5) {fill(blueish);ellipse(xx,yy,4,4);}
  else {fill(255); ellipse(xx,yy,3,3);}
  //println(i+" | "+centroids[i].x+" "+centroids[i].y);
}

//silhuete
for (int k=0; k<38; k++)
  {
    if (body[time][k]!=null) { 
      fill(250);
      noStroke();
      float x=map(body[time][k].x, 0, 640, 0, w);
      float y=map(body[time][k].y, 0, 480, 0, h);
      
      //ellipse(body[time][k].x,body[time][k].y,1,1); 
      ellipse(x, y, 1, 1);

    }
  }
  
}

// GUI drawing timeline
void drawTimeline(){
  
 fill(255);
  textSize(10);
 text("THE INTERPRETER", 10,20);
 
 text("SPEED: "+speed+" | FPS: "+int(frameRate)+" | MODE:"+mode  , 10,40);
 
 text(time  , 10,60);

  noStroke();
  fill(60);
  rect(10,70,width-352-20,30);
  fill(100);
  
  float timelineWidth=map(movie.time(),0,movie.duration(),0,width-352-20);
  rect(10,70,timelineWidth,30);
  //println(movie.time()+"  "+movie.duration());
  stroke(255);
  line(10,100, width-352-10,100);
}



