class Viz {

  Vec3D[] centroids;
  //small centroids for the thumbails
  Vec3D[] cMini;
  int id;
  // level of smoothness of the points. it is diferent form the first id and the following ones.
  float smooth=0.3;
  // size of the circle, on mode 1.
  float size=0.0;
  //contructor
  Viz(int _id) {
    id=_id;

    centroids= new Vec3D[9];
    cMini= new Vec3D[9];
    for (int i=0; i<9; i++) {
      centroids[i] = new Vec3D (0.0, 0.0, 0.0);
      cMini[i] = new Vec3D (0.0, 0.0, 0.0);
    }
  }

  void display() {

    //drawing, depending on the mode
    // if mode = 1 conecta A com B, if not conect C D E  

    if (mode==0) { 
      stroke(255);
      //stroke(255);
      fill(255);
      for (int i=0; i<9; i++) {
        point(centroids[i].x, centroids[i].y, centroids[i].z);
       // ellipse(centroids[i].x, centroids[i].y,5,5);
      }

      stroke(blueish);   
      for (int i=3; i<viz.length; i++) {
       line(viz[i].centroids[0].x, viz[i].centroids[0].y, viz[i].centroids[0].z, viz[i-1].centroids[0].x, viz[i-1].centroids[0].y, viz[i-1].centroids[0].z);
  
    }
    }

    if (mode==1) {
      stroke(255);
      fill(255, 20);
      //noFill();
      //float calcSize=abs(dist(centroids[0].x,centroids[0].y,centroids[2].x,centroids[2].y))*1;
      //println(calcSize);
      float calcSize=(abs(centroids[0].y-centroids[2].y)*3)+50;
      size+=(calcSize-size)*0.2;
      pushMatrix();
      translate(0, 0, centroids[0].z);

      ellipse(centroids[0].x, centroids[0].y, size, size);

      popMatrix();
      // line(centroids[2].x, centroids[2].y, centroids[2].z, centroids[4].x, centroids[4].y, centroids[4].z);

      //linha central
      //stroke(8,200,255,40);  
      stroke(blueish);
      point(centroids[0].x, centroids[0].y, centroids[0].z);  
      // line(viz[0].centroids[0].x, viz[0].centroids[0].y,viz[0].centroids[0].z, viz[3].centroids[0].x, viz[3].centroids[0].y,viz[3].centroids[0].z);
      for (int i=3; i<viz.length; i++) {
        line(viz[i].centroids[0].x, viz[i].centroids[0].y, viz[i].centroids[0].z, viz[i-1].centroids[0].x, viz[i-1].centroids[0].y, viz[i-1].centroids[0].z);
      }
    }

    if (mode==2) {
      stroke(255);
      line(centroids[5].x, centroids[5].y, centroids[5].z, centroids[6].x, centroids[6].y, centroids[6].z);
      line(centroids[2].x, centroids[2].y, centroids[2].z, centroids[4].x, centroids[4].y, centroids[4].z);
      line(centroids[7].x, centroids[7].y, centroids[7].z, centroids[8].x, centroids[8].y, centroids[8].z);


    }

    if (mode==3) {       
      noFill();
      stroke(255);
      beginShape();
      vertex(centroids[4].x, centroids[4].y, centroids[4].z);
      vertex(centroids[3].x, centroids[3].y, centroids[3].z);
      vertex(centroids[2].x, centroids[2].y, centroids[2].z);
      vertex(centroids[1].x, centroids[1].y, centroids[1].z);
      endShape(CLOSE);


//central Line
      stroke(blueish);
      line( centroids[0].x, centroids[0].y-5, centroids[0].z, centroids[0].x, centroids[0].y+5, centroids[0].z); 
      for (int i=3; i<viz.length; i++) {
        line(viz[i].centroids[0].x, viz[i].centroids[0].y, viz[i].centroids[0].z, viz[i-1].centroids[0].x, viz[i-1].centroids[0].y, viz[i-1].centroids[0].z);
      }
    }


  }



  void update( Vec3D zero, Vec3D um, Vec3D dois, Vec3D tres, Vec3D quatro, Vec3D cinco, Vec3D seis, Vec3D sete, Vec3D oito ) {

    //smoothing DATA
    smooth=0.4;
    float idd=id;
    // smooth= 0.2+(idd/50);
    //println(id+" "+smooth);

    //
    centroids[0].x+=(zero.x-centroids[0].x)*smooth;
    centroids[0].y+=(zero.y-centroids[0].y)*smooth;
    centroids[0].z=id*deep;
    //
    centroids[1].x+=(um.x-centroids[1].x)*smooth;
    centroids[1].y+=(um.y-centroids[1].y)*smooth;
    centroids[1].z=id*deep;
    //
    centroids[2].x+=(dois.x-centroids[2].x)*smooth;
    centroids[2].y+=(dois.y-centroids[2].y)*smooth;
    centroids[2].z=id*deep;
    //
    centroids[3].x+=(tres.x-centroids[3].x)*smooth;
    centroids[3].y+=(tres.y-centroids[3].y)*smooth;
    centroids[3].z=id*deep;
    //
    centroids[4].x+=(quatro.x-centroids[4].x)*smooth;
    centroids[4].y+=(quatro.y-centroids[4].y)*smooth;
    centroids[4].z=id*deep;

    //
    centroids[5].x+=(cinco.x-centroids[5].x)*smooth;
    centroids[5].y+=(cinco.y-centroids[5].y)*smooth;
    centroids[5].z=id*deep;
    //
    centroids[6].x+=(seis.x-centroids[6].x)*smooth;
    centroids[6].y+=(seis.y-centroids[6].y)*smooth;
    centroids[6].z=id*deep;
    //
    centroids[7].x+=(sete.x-centroids[7].x)*smooth;
    centroids[7].y+=(sete.y-centroids[7].y)*smooth;
    centroids[7].z=id*deep;
    //
    centroids[8].x+=(oito.x-centroids[8].x)*smooth;
    centroids[8].y+=(oito.y-centroids[8].y)*smooth;
    centroids[8].z=id*deep;
  }


// Small tumb graphics, on the GUI, top left.
  void tumb () {

    float w=176;
    float h=100;
    
    for (int i=0; i<9; i++) {
cMini[i].x= map(centroids[i].x,0,width,0,w)+w;
cMini[i].y= map(centroids[i].y,0,height,0,h);

    }
      // float miniSize;
      if (mode==1) {
        noFill();
        //stroke(blueish);
        stroke(255);
        //float eSize=abs(cMini[0].x-cMini[2].x)*2;
        float eSize=abs(dist(cMini[0].x,cMini[0].y,cMini[2].x,cMini[2].y))*2;
        ellipse(cMini[0].x,cMini[0].y, eSize,eSize);
        ellipse(cMini[0].x-w,cMini[0].y, eSize,eSize);
       
        noStroke();
        fill(blueish);
        ellipse(cMini[0].x,cMini[0].y, 4,4);
        ellipse(cMini[2].x,cMini[2].y, 4,4);
       // println(cMini[0].y+" "+cMini[2].y+" "+eSize);
        
      }
      
      if (mode==2) {
        stroke(255);
      line(cMini[5].x, cMini[5].y,  cMini[6].x, cMini[6].y);
      line(cMini[2].x, cMini[2].y,  cMini[4].x, cMini[4].y);
      line(cMini[7].x, cMini[7].y,  cMini[8].x, cMini[8].y);
      line(cMini[5].x-w, cMini[5].y,  cMini[6].x-w, cMini[6].y);
      line(cMini[2].x-w, cMini[2].y,  cMini[4].x-w, cMini[4].y);
      line(cMini[7].x-w, cMini[7].y,  cMini[8].x-w, cMini[8].y);
      
      noStroke();
        fill(blueish);
        ellipse(cMini[7].x,cMini[7].y, 4,4);
        ellipse(cMini[5].x,cMini[5].y, 4,4);
        ellipse(cMini[2].x,cMini[2].y, 4,4);
        ellipse(cMini[6].x,cMini[6].y, 4,4);
        ellipse(cMini[8].x,cMini[8].y, 4,4);
        ellipse(cMini[4].x,cMini[4].y, 4,4);

      }
      
      if (mode==3) {
        //Vizz on video
       noFill();
       stroke(255); 
      beginShape();
      vertex(cMini[4].x, cMini[4].y);
      vertex(cMini[3].x, cMini[3].y);
      vertex(cMini[2].x, cMini[2].y);
      vertex(cMini[1].x, cMini[1].y);
      endShape(CLOSE);
      
      //vizz on graph
       beginShape();
      vertex(cMini[4].x-w, cMini[4].y);
      vertex(cMini[3].x-w, cMini[3].y);
      vertex(cMini[2].x-w, cMini[2].y);
      vertex(cMini[1].x-w, cMini[1].y);
      endShape(CLOSE);
      
      //points
       noStroke();
        fill(blueish);
        ellipse(cMini[4].x,cMini[4].y, 4,4);
        ellipse(cMini[3].x,cMini[3].y, 4,4);
        ellipse(cMini[2].x,cMini[2].y, 4,4);
        ellipse(cMini[1].x,cMini[1].y, 4,4);
       
      
        
      }
    
  }
}

