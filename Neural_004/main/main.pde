import peasy.*;
import processing.net.*; 
Client myClient; 
int port = 5204;
ArrayList<Client> sockets;

int[][] cube_table;
int[][] food_table;
//PeasyCam cam;
//float xoff = 0;
//float yoff = 0;
int smallReward = 10;
int bigReward = 100;
    
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

PVector getPose(int x , int y){                 //get position of title on screen
  return new PVector(((height / scale) * (x - 0.5)) + height / scale, ((height / scale) * (y - 0.5)) + height / scale);
}
void draw_red_square(int x , int y){
   PVector v = getPose(x ,y); 
   fill(255 , 0 , 0);
   square(v.x , v.y , height / scale);
}


boolean getAvaliable(int x , int y){             //chceck if title is avaliable
  if((x < 0) || (y < 0) || (y > 134) || (x > 239)){
   return false; 
  }
  if(cube_table[x][y] > 0){
   return false; 
  }
  if(food_table[x][y] > 0){
   return false; 
  }
  return true;
}

int return_entity(int x , int y){           //  return type of object on title
  if((x < 0) || (y < 0) || (y > 134) || (x > 239)){
   return 0; 
  }
  if(cube_table[x][y] > 0){
   return 2; 
  }
  if(food_table[x][y] > 0){
   return 4; 
  }
  return 1;
}

int sendKilla(int x , int y , int dir , int team){   //tell cube that its being attacked / eat food
  if((x < 0) || (y < 0) || (y > 134) || (x > 239)){
     return 0; 
    }
  if(cube_table[x][y] > 0){
   cube c = cubes.get(cube_table[x][y]);
   c.killCommand(dir , team);
   return bigReward;
  }
  if(food_table[x][y] > 0){
    food f = foods.get(food_table[x][y]);
    f.self_grave();
    return smallReward;
  }
  return 0;
}

void setAvaliable(int x , int y , boolean mark){ //mark title as avaliable
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
ArrayList<food> foods;
ArrayList<Overlord> Overlords;

//int grid[][];
int scale = 128;

void setup(){

  cube_table = new int[240][135];
  food_table = new int[240][135];
  
  for(int i = 0; i < 240; i++){
    for(int n = 0; n < 135;n++){
      cube_table[i][n] = 0;
      food_table[i][n] = 0;
    }
  }
  
  sockets = new ArrayList<Client>();
  socket_begin();
  int xID = 0 , yID = 0;
  titles = new ArrayList<title>();
  cubes = new ArrayList<cube>();
  foods = new ArrayList<food>();
  Overlords = new ArrayList<Overlord>();
  fullScreen(P3D);
  
  transx = 0;
  transy =0 ;

  int title_id = 0;
  for(float x = 0.5*height / scale; x < width; x += round(width * 0.5625 / (scale))){
    for(float y = 0.5*height / scale; y < height; y += round(height / (scale))){
    title t = new title(new PVector(x , y) , height / scale , xID , yID , title_id);
    title_id++;

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
    add_random_food();
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

void add_random_food(){
  while(true){
  int x = round(random(1 , 235));
  int y = round(random(1 , 134));
    if(getAvaliable(x , y)){
      food f = new food(x , y);
      foods.add(f);
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
  
  //for (title t: titles) {
  //  t.display();
  //}
  
  
  for(int i = 0; i < 240; i++){
  for(int n = 0; n < 135;n++){
    cube_table[i][n] = 0;
    food_table[i][n] = 0;
  }
}
for (int i = foods.size()-1; i >= 0; i--) {
  food f = foods.get(i);
  food_table[f.xPos][f.yPos] = i;
}
for (int i = cubes.size()-1; i >= 0; i--) {
  cube c = cubes.get(i);
  cube_table[c.xPos][c.yPos] = i;
}
  
    for(Overlord o: Overlords){
    o.display();
    o.update();
  }
  for (int i = cubes.size()-1; i >= 0; i--) {
    cube c = cubes.get(i);
    if (c.isDead()) {
      add_random_player(c.colour , c.id , c.teamId);
      setAvaliable( c.xPos , c.yPos , true);
      cubes.remove(i);
    }else{
      c.display();
      c.update();
    }
  }
  fill(255 , 255 , 0);
  for (int i = foods.size()-1; i >= 0; i--) {
    food f = foods.get(i);
      if(f.isDead) {
        foods.remove(i);
      }else{
        f.display(); 
        
      }
  }
  

  
  //for (int i = cubes.size()-1; i >= 0; i--) {
  //  cube c = cubes.get(i);
  //  if (c.isDead()) {
  //    setAvaliable( c.xPos , c.yPos , true);
  //    cubes.remove(i);
  //  }
  //}
  
    for (int i = Overlords.size()-1; i >= 0; i--) {
    Overlord c = Overlords.get(i);
    if (c.isDead()) {
      setAvaliable( c.xPos , c.yPos , true);
      Overlords.remove(i);
    }
  }
  
  
  
  //cam.beginHUD();
  //text(frameRate , 20 , 20);
  //cam.endHUD();
  fill(255);
  text(frameRate , 20 , 20);
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
  //xoff = transx - mouseX;
  //yoff = transy - mouseY;
}
void mouseDragged() {
  //transx = mouseX + xoff;
  //transy = mouseY + yoff;
  //if (transx < -2000) {
  //  transx = -2000;
  //}
  //if (transy < -2000) {
  //  transy = -2000;
  //}
  //if (transy > 2000) {
  //  transy = 2000;
  //}
  //if (transx > 2000) {
  //  transx = 2000;
  //}
}
void mouseReleased() {
  cursor(ARROW);
}
