import 'dart:io';

import 'package:socket_io/socket_io.dart';

import 'connection/client_connection.dart';
import 'model/server_context.dart';

void main() {
  var state = ServerContext(Server());
  state.server.on('connection', (data) {
    state.connections.add(ClientConnection(socket: data, state: state));
  });
  var port = Platform.environment['PORT'];
  state.server.listen(port == null ? 3000 : int.parse(port));
}
