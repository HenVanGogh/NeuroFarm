import peasy.*;
import processing.net.*; 
Client myClient; 
int port = 5204;
ArrayList<Client> sockets;

 
    PeasyCam cam;
    float xoff = 0;
float yoff = 0;
    
    
class title{
  PVector pos;
  int size;
  
  int yID;
  int xID;
  
  int id;
  
  boolean awaliable = true;
  boolean killa = false;
  boolean feed = false;
  
  
  title(PVector Pos, int Size , int x , int y , int Id){
    pos = Pos;
    size = Size;
    xID = x;
    yID = y;
    id = Id;
    
  }
  
  void display(){
    if(killa){
      fill(130 , 0 , 0);
      rect(pos.x , pos.y , size , size); 
      killa = false;
    }else if(feed){
      fill(0 , 130 , 130);
      rect(pos.x , pos.y , size , size); 
    }else{
      fill(40);
      rect(pos.x , pos.y , size , size); 
    }
  }
  int set_killa(){
   killa = true; 
   if(feed == true){
     feed = false;
     return 10; 
   }else{
     return 0;
   }
  }
  
  
  
}

//PVector getPose(int x , int y){
//for (title t: titles) {
//    if((t.xID == x) && (t.yID == y)){
//     return t.pos; 
//    }
//  }
//  return new PVector(-1 , -1);
//}

PVector getPose(int x , int y){

  return new PVector(((height / scale) * (x - 0.5)) + height / scale, ((height / scale) * (y - 0.5)) + height / scale);
}



//boolean getAvaliable(int x , int y){
//  for (title t: titles) {
//    if((t.xID == x) && (t.yID == y)){
//     return t.awaliable; 
//    }
//  }
//  return false;
//}
boolean getAvaliable(int x , int y){
  
  if((x < 0) || (y < 0) || (y > 134) || (x > 239)){
   return false; 
  }
  
  for (title t: titles) {
    if((t.xID == x) && (t.yID == y)){
    }
  }

  int i = x * 135 + y;
  title t = titles.get(i);
  return t.awaliable;
}

int sendKilla(int x , int y , int dir , int team){
  int revard = 0;
  for (cube c: cubes) {
    if((c.xPos == x) && (c.yPos == y)){
     c.killCommand(dir , team);
     revard += 100;
     break;
    }
  }
  for (title c: titles) {
    if((c.xID == x) && (c.yID == y)){
     c.set_killa();
     return revard;
    }
  }
   for (Overlord c: Overlords) {
    if((c.xPos == x) && (c.yPos == y)){
     c.killCommand(dir , team);
     return revard;
    }
  }
  return 0;
}

void setAvaliable(int x , int y , boolean mark){
  for (title t: titles) {
    if((t.xID == x) && (t.yID == y)){
     t.awaliable = mark; 
    }
  }
}


float transx;
float transy;

ArrayList<title> titles;
ArrayList<cube> cubes;
ArrayList<Overlord> Overlords;

//int grid[][];
int scale = 128;

void setup(){
  sockets = new ArrayList<Client>();
  
  int xID = 0 , yID = 0;
  titles = new ArrayList<title>();
  cubes = new ArrayList<cube>();
  Overlords = new ArrayList<Overlord>();
  fullScreen(P3D);
  
  cam = new PeasyCam(this, 0 , 0 , 0 , 100); 
  cam.setMinimumDistance(110); 
  cam.setMaximumDistance(500);
  
  cam.setLeftDragHandler(null);
  cam.setCenterDragHandler(null);
  
  transx = 0;
  transy =0 ;
  
  //cam.setYawRotationMode();   // like spinning a globe
  //cam.setPitchRotationMode(); // like a somersault
  //cam.setRollRotationMode();  // like a radio knob
  //cam.setSuppressRollRotationMode(); 
  
  int title_id = 0;
  for(float x = 0.5*height / scale; x < width; x += round(width * 0.5625 / (scale))){
    for(float y = 0.5*height / scale; y < height; y += round(height / (scale))){
    title t = new title(new PVector(x , y) , height / scale , xID , yID , title_id);
    title_id++;
    //print(xID); print("  "); print(yID); println("");
    titles.add(t);
    yID++;
  }
  yID = 0;
  xID++;
  }
  println(width / round(width * 0.5625 / (scale)));
  println(height / round(height / (scale)));
  
  cube player = new cube(5 , 5 , height / scale , new PVector(255 , 255 , 0) , 0 , 1);
  cubes.add(player);
  
  for(int i = 0; i < 100; i++){
    add_random_player(random_color() , i , i);
  }
  
  /*
  Overlord player3 = new Overlord(127 , 227 , height / scale , new PVector(255 , 0 , 255) , 0 , 0);
  Overlords.add(player3);
  */
  
 smooth();
  
}

void add_random_player(PVector _color, int id , int team){
  while(true){
    int x = round(random(1 , 235));
    int y = round(random(1 , 134));
  
    if(add_player(x , y , _color , id , team) != 0) {
      break;
    }
  }
}


int add_player(int xpos , int ypos , PVector _color, int id , int team){
  if(getAvaliable(xpos , ypos)){
  cube player = new cube(xpos , ypos , height / scale , _color , id , team);
  cubes.add(player);
  return 1;
  }
  return 0;
}

PVector random_color(){
 return new PVector(random(0 , 254) , random(0 , 254) , random(0 , 254)); 
}


void draw(){
  background(0);
  translate(transx, transy);
  rectMode(CENTER);
  fill(40);
  
  for (title t: titles) {
    t.display();
  }
  
  
    for(Overlord o: Overlords){
    o.display();
    o.update();
  }
  for(cube c: cubes){
    c.display();
    c.update();
  }
  

  
  for (int i = cubes.size()-1; i >= 0; i--) {
    cube c = cubes.get(i);
    if (c.isDead()) {
      setAvaliable( c.xPos , c.yPos , true);
      cubes.remove(i);
    }
  }
  
    for (int i = Overlords.size()-1; i >= 0; i--) {
    Overlord c = Overlords.get(i);
    if (c.isDead()) {
      setAvaliable( c.xPos , c.yPos , true);
      Overlords.remove(i);
    }
  }
  
  
  
  cam.beginHUD();
  text(frameRate , 20 , 20);
  cam.endHUD();
}


void keyPressed() {
  if(key == 'a'){
    cube c = cubes.get(0);
    c.moveHorizontally(false);
    
  }
  if(key == 'w'){
    cube c = cubes.get(0);
    c.moveVertically(false);
    
  }
  if(key == 'd'){
    cube c = cubes.get(0);
    c.moveHorizontally(true);
    
  }
  if(key == 's'){
    cube c = cubes.get(0);
    c.moveVertically(true);
    
  }
    if(key == 'q'){
    cube c = cubes.get(0);
    c.rotateMouth(true);
    
    }
    if(key == 'e'){
    cube c = cubes.get(0);
    c.rotateMouth(false);
    
  }
  if(key == 'r'){
    cube c = cubes.get(1);
    c.rotateMouth(true);
    
    }
    if(key == 'y'){
    cube c = cubes.get(1);
    c.rotateMouth(false);
    
  }
  
  if(key == 't'){
    cube c = cubes.get(1);
    c.moveHorizontally(false);
  }
  if(key == 'f'){
    cube c = cubes.get(1);
    c.moveVertically(false);
  }
  if(key == 'g'){
    cube c = cubes.get(1);
    c.moveHorizontally(true);
  }
  if(key == 'h'){
    cube c = cubes.get(1);
    c.moveVertically(true);
  }
}




void mousePressed() {
  cursor(HAND);
  xoff = transx - mouseX;
  yoff = transy - mouseY;
}
void mouseDragged() {
  transx = mouseX + xoff;
  transy = mouseY + yoff;
  if (transx < -2000) {
    transx = -2000;
  }
  if (transy < -2000) {
    transy = -2000;
  }
  if (transy > 2000) {
    transy = 2000;
  }
  if (transx > 2000) {
    transx = 2000;
  }
}
void mouseReleased() {
  cursor(ARROW);
}
