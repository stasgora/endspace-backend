import '../model/game.dart';
import '../model/planet.dart';
import '../model/task.dart';
import 'connection.dart';

mixin GameManagement on Connection {
  Game get game => room!;

  void onStartGame(dynamic args) {
    _createPlanet();
    broadcast('gameStarted', _dashboardState());
  }

  Map<String, dynamic> _dashboardState() => {
        'planet': game.planet.name,
        'energy': game.energy,
        'endTime': game.planet.endTime.millisecondsSinceEpoch,
        'tasks': game.planet
            .tasksWith((task) => task.state == TaskState.available),
      };

  void _createPlanet() {
    game.planets.add(Planet(
      'CP-${game.planets.length}',
      Duration(minutes: 10),
    ));
    game.planet.addTasks([
      Task(TaskType.test, 1, .2),
    ]);
  }
}
