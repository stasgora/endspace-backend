import 'package:socket_io/socket_io.dart';

import '../model/game.dart';
import '../model/server_context.dart';

abstract class Connection {
  final Socket socket;
  final ServerContext context;
  Game? room;

  Connection({required this.socket, required this.context});

  void broadcast(String event, [dynamic args]) {
    context.server.to(room!.code).emit(event, args);
  }
}
