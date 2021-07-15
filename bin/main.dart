import 'dart:io';

import 'package:socket_io/socket_io.dart';

import 'connection.dart';
import 'model/server_state.dart';

void main() {
  var state = ServerState(Server());
  state.server.on('connection', (data) {
    state.connections.add(Connection(socket: data, state: state));
  });
  var port = Platform.environment['PORT'];
  state.server.listen(port == null ? 3000 : int.parse(port));
}