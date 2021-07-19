import '../model/game.dart';
import 'connection.dart';

mixin GameManagement on Connection {
  Game get game => room!;

  void onPlanetData(dynamic args) {
    socket.emit('planetDataResponse', {
      'planet': 'XC-20',
      'energy': 0.2,
      'endTime': DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch,
    });
  }
}
