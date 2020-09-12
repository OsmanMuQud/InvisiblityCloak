//by Osman Mustafa Quddusi
import processing.video.*;
Capture cam;
IntList col= new IntList();
float in=40;
float colo=2.0;
PImage mask=createImage(1280,720,RGB);
PImage mask2=createImage(1280,720,RGB);
PImage mask3=createImage(1280,720,RGB);
boolean first=true;
void setup()
{
  size(1280,720);
  cam=new Capture(this,1280,720);
  cam.start();
}
void draw()
{
  if(cam.available())
  {
    cam.read();
    mask.loadPixels();
    if(first){
      for(int i=0;i<mask.pixels.length;i++)
      {
          mask.pixels[i]=cam.pixels[i];
      }
      mask.updatePixels();
      first=false;
    }
  }
  image(cam,0,0);
  checkCol();
  println(in);
  compressor();
}
void disp(PImage img)
{
  pushMatrix();
  translate(img.width,0);
  scale(-1,1);
  image(img,0,0);
  popMatrix();
}

void mousePressed()
{
  loadPixels();
  col.append(pixels[mouseX+mouseY*width]);
  
}
void checkCol()
{
  loadPixels();
  for(int x=0;x<width;x++)
  {
    for(int y=0;y<height;y++)
    {
      if(detectCol(x,y))
      {
        pixels[x+y*width]=mask.pixels[x+y*width];
      }
    }
  }
  updatePixels();
}
boolean detectCol(int x,int y)
{
  boolean bVal=abs(brightness(mask2.pixels[x+y*width])-brightness(mask3.pixels[x+y*width]))>255/4;
  for(int i=0;i<col.size();i++)
  if(distCol(pixels[x+y*width],col.get(i))<in&&!bVal)
    return true;
    return false;
}
float distCol(color a,color b)
{
  return dist(red(a),green(a),blue(a),red(b),green(b),blue(b));
}
void keyPressed()
{
  //these can be use to change the threshold form selected color
  //if(keyCode==UP){
  //in+=0.1;}
  //if(keyCode==DOWN){
  //in-=0.1;}
  if(key=='c'&&col.size()>0)
  {
    col.pop();
  }
  
}
void compressor()
{
  mask2.loadPixels();
  for(int i=0;i<cam.pixels.length;i++)
  {
    float red=red(cam.pixels[i]);
    float blue=blue(cam.pixels[i]);
    float green=green(cam.pixels[i]);
    
    float r=reduce(red,colo);
    float b=reduce(blue,colo);
    float g=reduce(green,colo);
    
    int redy=(int) map(r,0,colo,0,255);
    int bluey=(int) map(b,0,colo,0,255);
    int greeny=(int) map(g,0,colo,0,255);
    mask2.pixels[i]=color(brightness(color(redy,greeny,bluey)));
  }
  mask2.updatePixels();
  mask3.loadPixels();
  for(int i=0;i<cam.pixels.length;i++)
  {
    float red=red(cam.pixels[i]);
    float blue=blue(cam.pixels[i]);
    float green=green(cam.pixels[i]);
    
    float r=reduce(red,colo+2);
    float b=reduce(blue,colo+2);
    float g=reduce(green,colo+2);
    
    int redy=(int) map(r,0,colo+2,0,255);
    int bluey=(int) map(b,0,colo+2,0,255);
    int greeny=(int) map(g,0,colo+2,0,255);
    mask3.pixels[i]=color(brightness(color(redy,greeny,bluey)));
  }
  mask3.updatePixels();
  
  
}

int reduce(float c,float n)
{
  int r=(int)((n*c)/255);
  return r;
}
