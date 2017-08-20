AccelerometerManager accel;
float ax, ay, az;
float ex, ey, vx,vy;
Obstacle[] obstacles=new Obstacle[50];
void setup() {
  ex=width/2;
  vx=0;
  ey=height/2;
  vy=0;
  frameRate(25);
  accel = new AccelerometerManager(this);
  orientation(PORTRAIT);
  noLoop();
  for (int f=1; f <obstacles.length; f++){
    obstacles [f]= new Obstacle();
    obstacles[f].x= int (random (width));
    obstacles[f].y= int (random (height));
  }
}

void draw() {
  float gravityx, gravityy;
  //it seems ax is inverted.
  gravityx=-9.8f*ax/10;
  gravityy=9.8f*ay/10;
  vx=vx+(25f/60f)*gravityx;
  vy=vy+(25f/60f)*gravityy;
  ex=ex+vx;
  ey=ey+vy;
  if (ex <0) {
    ex= 0;
    vx=0;
  }
  if (ex > width) {
    ex= width;
    vx=0;
  }
  if (ey<0) {
    ey= 0;
    vy=0;
  }
  if (ey > height) {
    ey= height ;
    vy=0;
  }
  background (0);
  fill(255);
  for (int f=1; f <obstacles.length; f++){
    obstacles [f].draw();
    if (obstacles [f].testhit (ex,ey,10.0) ){
      vx=-vx;
      vy=-vy;
      obstacles [f].bumpout(ex,ey,10);
      ex=obstacles [f].bumpx;
      ey=obstacles [f].bumpy;
    } 
  }
  
  textSize(70);
  ellipseMode (RADIUS);
  ellipse (ex,ey,10.0, 10.0);
  
  
}

public void resume() {
  if (accel != null) {
    accel.resume();
  }
}

public void pause() {
  if (accel != null) {
    accel.pause();
  }
}

public void shakeEvent(float force) {
  println("shake : " + force);
}

public void accelerationEvent(float x, float y, float z) {
//  println("acceleration: " + x + ", " + y + ", " + z);
  ax = x;
  ay = y;
  az = z;
  redraw();
}
public class xy {
  float x;
  float y;
}
public class Obstacle {
  public float x;
  public float y;
  public float radius;
  public float bumpx;
  public float bumpy;
  Obstacle (){
    y=random (height);
    x=random (width);
    radius=50;
  }
  public void draw (){
    ellipseMode (RADIUS );
    ellipse(x,y,radius,radius);
  }
  public boolean testhit (float x2,float y2, float radius2){
    if (dist(x,y,x2,y2)<(radius2+radius)){
      return true;
      
    } else {
      return false;
    }
  }
  
  public void bumpout (float xbola, float ybola, float rbola){
    float fn,sig,rad,num,x3,y3;
    float robstaculo,xobstaculo,yobstaculo;
    xobstaculo=this.x;
    yobstaculo=this.y;
    robstaculo=this.radius;
    if ( testhit (xbola,ybola,rbola))
    {
       rad=robstaculo+rbola;
     if (xobstaculo !=xbola) {
       fn=((yobstaculo-ybola)/(xobstaculo-xbola));
       sig=(xobstaculo>xbola? -1:1);
       num=sqrt ((rad*rad)/((fn*fn)+1));
       x3=xobstaculo+sig*num;
       y3=yobstaculo+sig*num*fn;
     } else {
       x3=xobstaculo;
       y3=yobstaculo+robstaculo+rbola; 
     }
      this.bumpx=x3;
      this.bumpy=y3;
   
    } else {
     this.bumpx=xbola;
     this.bumpy=ybola;
     println ("testhit=false");
    }
  }
}