import '../model/game.dart';
import 'connection.dart';

// ignore_for_file: avoid_dynamic_calls
mixin RoomManagement on Connection {
  void onCreateRoom(dynamic args) {
    room = Game();
    context.games[room!.code] = room!;
    socket.emit('roomCreated', room!.code);
    _joinRoom(args['name']);
  }

  void onJoinRoom(dynamic args) {
    var game = context.games[args['roomCode']];
    if (game == null) {
      socket.emit('unknownCode');
      return;
    }
    if (game.players.containsKey(socket.id)) {
      socket.emit('alreadyInRoom');
      return;
    }
    room = game;
    _joinRoom(args['name']);
  }

  void leaveRoom() {
    if (room == null) return;
    context.roomAssignment.remove(socket.id);
    room?.removePlayer(socket.id);
    socket.leave(room!.code, (_) {});
    if (room!.players.isNotEmpty) _playersChanged();
    else {
      context.games.remove(room!.code);
      room = null;
    }
  }

  void _playersChanged() {
    broadcast('playersChange', room!.players.values.toList());
  }

  void _joinRoom(String player) {
    socket.join(room!.code);
    context.roomAssignment[socket.id] = room!.code;
    room?.addPlayer(socket.id, player);
    socket.emit('roomJoined', {
      'code': room!.code,
      'players': room!.players.values.toList(),
    });
    _playersChanged();
  }
}