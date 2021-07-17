import 'package:socket_io/socket_io.dart';

import '../connection/connection.dart';
import 'game.dart';

class ServerContext {
  final roomAssignment = <String, String>{};
  final games = <String, Game>{};
  final Server server;
  final connections = <Connection>[];

  ServerContext(this.server);
}