import 'dart:math';

final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
final _codeLength = 8;

class Game {
  final Map<String, String> players = {};
  late final String code;

  double fuel = 0;
  int points = 0;

  final _random = Random();

  Game() {
    code = String.fromCharCodes(Iterable.generate(
      _codeLength,
      (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
    ));
    print('✨ New room created: $code');
  }

  void addPlayer(String id, String name) {
    print('➕ $name joined the game $code');
    players[id] = name;
  }

  void removePlayer(String id) {
    print('➖ ${players[id]} left the game $code');
    players.remove(id);
    if (players.isEmpty) print('🚫 last player left the game $code');
  }
}
