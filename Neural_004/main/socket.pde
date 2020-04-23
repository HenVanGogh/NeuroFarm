void socket_begin(){
  for(int i = 0 ; i < 100; i++){
    myClient = new Client(this, "127.0.0.1", port + i); 
    sockets.add(myClient);
  }
  
}
