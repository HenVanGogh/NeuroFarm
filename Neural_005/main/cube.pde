class cube{
 int xPos , yPos;
 int size;
 PVector colour;
 int rotation = 0;
 int id;
 int health = 10;
 int teamId;
 int feed = 10000;
 int reward = 0;
 
 byte[] vision_table;
  
  cube(int x , int y , int Size , PVector Color , int Id , int team){
    xPos = x;
    yPos = y;
    size = Size;
    colour = Color;
    id = Id;
    teamId = team;
    setAvaliable(xPos , yPos , false);
    vision_table = new byte[256];
    
    int vision_pointer = 0;
    for(int i = xPos - 7; i <= xPos + 7; i++){
      for(int n = yPos - 7; n <= yPos + 7; n++){
        vision_table[vision_pointer] = byte(return_entity(i , n));
        vision_pointer++;
      }
    }
    vision_table[225] = byte(reward);
    send_vision(id , vision_table);
  }
  
  void display(){

   PVector pos = getPose(xPos , yPos);
   fill(colour.x , colour.y , colour .z);
   rect(pos.x , pos.y , size , size);
   
   if(rotation <= -1){
     rotation = 3;
   }else if(rotation >= 4){
     rotation = 0;
   }
   
   if(rotation == 2){
     circle(pos.x , pos.y  - size / 2, size / 2);
   }else if(rotation == 1){
     circle(pos.x  - size / 2, pos.y , size / 2);
   }else if(rotation == 0){
     circle(pos.x , pos.y + size / 2 , size / 2);
   }else if(rotation == 3){
     circle(pos.x + size / 2 , pos.y , size / 2);
   }
  }
  
  
  
  boolean isDead(){
    if((health <= 0) || (feed <= 0)){
      im_dead(id);
      return true;
    }else{
      return false;
      
    }
  }
  
  void killCommand(int dir , int team){
    if(team != teamId){
   if(dir == rotation){
    health -= 5;
   }else if(abs(dir - rotation) == 2){    
     return;
   }else{
     health -= 2;    
   }
    }
  }
  
  void update(){
    int command = receive_command(id);
    if(id == 0){
     println(command); 
    }
    switch(command) {
      case 0: 
        break;
      case 1: 
      moveHorizontally(true);
        break;
      case 2: 
      moveHorizontally(false);
        break;
      case 3: 
      moveVertically(true);
        break;
      case 4: 
      moveVertically(false);
        break;
      case 5: 
      rotateMouth(true);
        break;
      case 6: 
       rotateMouth(false);
        break;
    }
    
    
   feed--;
   if(rotation <= -1){
     rotation = 3;
   }else if(rotation >= 4){
     rotation = 0;
   }
   if(rotation == 1){
     sendKilla(xPos - 1 , yPos  , rotation , teamId);
   }else if(rotation == 2){
     sendKilla(xPos  , yPos - 1 , rotation, teamId);
   }else if(rotation == 3){
     sendKilla(xPos + 1, yPos  , rotation, teamId);
   }else if(rotation == 0){
     sendKilla(xPos  , yPos + 1, rotation, teamId);
   }
   
   for(int i = 0; i < 256; i++){
      vision_table[i] = 0;
    }
    
    int vision_pointer = 0;
    for(int i = xPos - 7; i <= xPos + 7; i++){
      for(int n = yPos - 7; n <= yPos + 7; n++){
        vision_table[vision_pointer] = byte(return_entity(i , n));
        vision_pointer++;
      }
    }
    vision_table[225] = byte(reward);
    send_vision(id , vision_table);
  }

  void rotateMouth(boolean dir){
    if(dir){
     rotation--; 
    }else{
      rotation++;
    }
  }
  
  void moveHorizontally(boolean dir){
    if(dir){
     if(getAvaliable(xPos + 1 , yPos)){
      setAvaliable(xPos , yPos , true);
       xPos++;
       setAvaliable(xPos , yPos , false);
     }
    }else{
      if(getAvaliable(xPos - 1 , yPos)){
       setAvaliable(xPos , yPos , true);
       xPos--;
       setAvaliable(xPos , yPos , false);
     }
    }
  }
  
  void moveVertically(boolean dir){
     if(dir){
     if(getAvaliable(xPos, yPos + 1)){
       setAvaliable(xPos , yPos , true);
       yPos++;
       setAvaliable(xPos , yPos , false);
     }
    }else{
      if(getAvaliable(xPos, yPos -1)){
       setAvaliable(xPos , yPos , true);
       yPos--;
       setAvaliable(xPos , yPos , false);
     }
    }
  }
  
  
  
  
  
  
  }
  
  
  
  
  
class food{
 int xPos , yPos;
 int size = height / scale;
 PVector colour = new PVector(255 , 255 , 0);
 boolean isDead = false;
  
  food(int x , int y){
    xPos = x;
    yPos = y;
    setAvaliable(x , y , false);
  }
  
  boolean isDead(){
    return isDead;
  }
  
  void self_grave(){
   isDead = true; 
  }
  
  void display(){
    PVector pos = getPose(xPos , yPos);
    circle(pos.x , pos.y  , size); 
  }
}
  
