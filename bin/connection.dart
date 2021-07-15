import 'package:socket_io/socket_io.dart';

import 'model/game.dart';
import 'model/server_state.dart';

// ignore_for_file: avoid_dynamic_calls
class Connection {
  final Socket socket;
  final ServerState state;
  late Game game;

  Connection({required this.socket, required this.state}) {
    socket.on('createRoom', onCreateRoom);
    socket.on('joinRoom', onJoinRoom);
    socket.on('leaveRoom', (args) => _leaveRoom());
    socket.on('disconnect', (reason) => _leaveRoom());
  }

  void onCreateRoom(dynamic args) {
    game = Game();
    state.games[game.code] = game;
    socket.emit('roomCreated', game.code);
    _joinRoom(args['name']);
  }

  void onJoinRoom(dynamic args) {
    var game = state.games[args['roomCode']];
    if (game == null) {
      socket.emit('unknownCode');
      return;
    }
    if (game.players.containsKey(socket.id)) {
      socket.emit('alreadyInRoom');
      return;
    }
    this.game = game;
    _joinRoom(args['name']);
  }

  void _playersChanged() {
    state.server.to(game.code).emit(
      'playersChange',
      game.players.values.toList(),
    );
  }

  void _joinRoom(String player) {
    socket.join(game.code);
    state.roomAssignment[socket.id] = game.code;
    game.addPlayer(socket.id, player);
    socket.emit('roomJoined', {
      'code': game.code,
      'players': game.players.values.toList(),
    });
    _playersChanged();
  }

  void _leaveRoom() {
    state.roomAssignment.remove(socket.id);
    game.removePlayer(socket.id);
    socket.leave(game.code, (_) {});
    if (game.players.isNotEmpty) _playersChanged();
  }
}
