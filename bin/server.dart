import 'dart:io';
import 'dart:math';

import 'package:socket_io/socket_io.dart';

void main() {
  var server = Server();
  server.on('connection', (socket) {
    void joinRoom(String player, String roomCode, {bool existing = false}) {
      if (existing) {
        var room = socket.adapter.rooms[roomCode];
        if (room == null) {
          socket.emit('unknownCode');
          return;
        }
        if (room.sockets.containsKey(socket.id)) {
          socket.emit('alreadyInRoom');
          return;
        }
      }
      socket.join(roomCode);
      socket.emit('roomJoined', roomCode);
      server.to(roomCode).emit('playersChange');
      print('➕ $player joined the room $roomCode');
    }
    socket.on('createRoom', (args) {
      var roomCode = createRoomCode();
      socket.emit('roomCreated', roomCode);
      print('✨ New room created: $roomCode');
      joinRoom(args['name'], roomCode);
    });
    socket.on('joinRoom', (args) {
      joinRoom(args['name'], args['roomCode']);
    });
    socket.on('leaveRoom', (args) {
      var roomCode = args['roomCode'];
      socket.leave(roomCode, (_) {});
      server.to(roomCode).emit('playersChange');
      print('➖ ${args['name']} left the room $roomCode');
    });
  });
  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 3000 : int.parse(portEnv);
  server.listen(port);
}

String createRoomCode([int length = 8]) {
  var random = Random();
  final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
