class cube{
 int xPos , yPos;
 int size;
 PVector colour;
 int rotation = 0;
 int id;
 int health = 10;
 int teamId;
  
  cube(int x , int y , int Size , PVector Color , int Id , int team){
    xPos = x;
    yPos = y;
    size = Size;
    colour = Color;
    id = Id;
    teamId = team;
    setAvaliable(xPos , yPos , false);
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
    if(health <= 0){
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
   
   if(rotation <= -1){
     rotation = 3;
   }else if(rotation >= 4){
     rotation = 0;
   }
   /*
   if(rotation == 3){
     sendKilla(xPos , yPos - 1 , rotation);
   }else if(rotation == 2){
     sendKilla(xPos - 1 , yPos , rotation);
   }else if(rotation == 1){
     sendKilla(xPos , yPos + 1 , rotation);
   }else if(rotation == 0){
     sendKilla(xPos + 1 , yPos , rotation);
   }
   */
   if(rotation == 1){
     sendKilla(xPos - 1 , yPos  , rotation , teamId);
   }else if(rotation == 2){
     sendKilla(xPos  , yPos - 1 , rotation, teamId);
   }else if(rotation == 3){
     sendKilla(xPos + 1, yPos  , rotation, teamId);
   }else if(rotation == 0){
     sendKilla(xPos  , yPos + 1, rotation, teamId);
   }
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
  
