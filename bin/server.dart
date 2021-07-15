import 'dart:io';
import 'dart:math';

import 'package:socket_io/socket_io.dart';

void main() {
  var playerToRoom = <String, String>{};
  var idToPlayer = <String, String>{};
  
  var server = Server();
  server.on('connection', (socket) {
    List getRoomPlayers(String roomCode) {
      var room = socket.adapter.rooms[roomCode]!;
      return room.sockets.keys.map((e) => idToPlayer[e]).toList();
    }
    void onPlayersChanged(String roomCode) {
      server.to(roomCode).emit('playersChange', getRoomPlayers(roomCode));
    }
    void joinRoom(String player, String roomCode) {
      socket.join(roomCode);
      playerToRoom[socket.id] = roomCode;
      idToPlayer[socket.id] = player;
      socket.emit('roomJoined', {
        'code': roomCode,
        'players': getRoomPlayers(roomCode),
      });
      onPlayersChanged(roomCode);
      print('➕ $player joined the room $roomCode');
    }
    socket.on('createRoom', (args) {
      var roomCode = createRoomCode();
      socket.emit('roomCreated', roomCode);
      print('✨ New room created: $roomCode');
      joinRoom(args['name'], roomCode);
    });
    socket.on('joinRoom', (args) {
      var roomCode = args['roomCode'];
      var room = socket.adapter.rooms[roomCode];
      if (room == null) {
        socket.emit('unknownCode');
        return;
      }
      if (room.sockets.containsKey(socket.id)) {
        socket.emit('alreadyInRoom');
        return;
      }
      joinRoom(args['name'], roomCode);
    });
    socket.on('leaveRoom', (args) {
      var roomCode = args['roomCode'];
      socket.leave(roomCode, (_) {});
      onPlayersChanged(roomCode);
      print('➖ ${args['name']} left the room $roomCode');
    });
    socket.on('disconnect', (reason) {
      var roomCode = playerToRoom[socket.id]!;
      idToPlayer.remove(socket.id);
      socket.leave(roomCode, (_) {});
      print('⛔ ${socket.id} left the room $roomCode');
      if (socket.adapter.rooms.containsKey(roomCode))
        onPlayersChanged(roomCode);
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
