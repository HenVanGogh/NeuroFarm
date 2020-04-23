void socket_begin(){
  for(int i = 0 ; i < 100; i++){
    myClient = new Client(this, "127.0.0.1", port + i); 
    sockets.add(myClient);
  }
}

void send_vision(int id , byte[] vision){
  Client s = sockets.get(id);
  s.write(byte(1));
  s.write(vision);
}

void im_dead(int id){
  Client s = sockets.get(id);
  s.write(byte(0));
}
