import 'package:socket_io/socket_io.dart';

import '../model/server_context.dart';
import 'connection.dart';
import 'game_management.dart';
import 'room_management.dart';

class ClientConnection extends Connection with RoomManagement, GameManagement {
  ClientConnection({required Socket socket, required ServerContext state})
      : super(socket: socket, context: state) {
    print('⬆️ New client connected');

    socket.on('joinTask', onJoinTask);
    socket.on('leaveTask', onLeaveTask);
    socket.on('taskAction', onTaskAction);

    socket.on('createRoom', onCreateRoom);
    socket.on('joinRoom', onJoinRoom);
    socket.on('startGame', onStartGame);
    socket.on('leaveRoom', (args) => leaveRoom());
    socket.on('disconnect', (reason) {
      leaveRoom();
      state.connections.remove(socket.id);
      print('⬇️ Client disconnected');
    });
  }
}
