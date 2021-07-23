import 'dart:math';

import 'planet.dart';
import 'task.dart';

final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
final _codeLength = 8;

class Game {
  final Map<String, String> players = {};
  late final String code;

  final planets = <Planet>[];
  double energy = 0;

  Planet get planet => planets.last;

  final _random = Random();

  Game() {
    code = String.fromCharCodes(Iterable.generate(
      _codeLength,
      (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
    ));
    print('✨ New room created: $code');
  }

  void addPlayer(String id, String name) {
    print('➕ $name joined the room $code');
    players[id] = name;
  }

  void removePlayer(String id) {
    print('➖ ${players[id]} left the room $code');
    players.remove(id);
    if (players.isEmpty) print('🚫 last player left the room $code');
  }

  Map<String, dynamic> toJson() => {
        'planet': planet.name,
        'energy': energy,
        'endTime': planet.endTime.millisecondsSinceEpoch,
        'tasks': planet.tasks.values.map((t) => t.toJson()).toList(),
      };
}
