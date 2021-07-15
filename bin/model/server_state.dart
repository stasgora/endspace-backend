import 'package:socket_io/socket_io.dart';

import '../connection.dart';
import 'game.dart';

class ServerState {
  final roomAssignment = <String, String>{};
  final games = <String, Game>{};
  final Server server;
  final connections = <Connection>[];

  ServerState(this.server);
}