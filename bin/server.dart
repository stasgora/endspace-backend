import 'dart:io';

import 'package:socket_io/socket_io.dart';

void main() {
  var io = Server();
  io.on('connection', (client) {
    print('connection default namespace');
    client.on('msg', (data) {
      print('data from default => $data');
      client.emit('fromServer', "ok");
    });
  });
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 3000 : int.parse(portEnv);
  io.listen(port);
}
