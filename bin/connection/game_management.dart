import '../model/game.dart';
import '../model/planet.dart';
import '../model/task.dart';
import 'connection.dart';

mixin GameManagement on Connection {
  Game get game => room!;
  String get player => game.players[socket.id]!;

  void onStartGame(dynamic args) {
    _createPlanet();
    broadcast('gameStarted', game.toJson());
  }

  void onTaskAction(dynamic args) {
    var task = game.planet.tasks[args];
    if (task == null) return;
    task.state = TaskState.completed;
    _taskChanged(task);
  }

  void onJoinTask(dynamic args) {
    var task = game.planet.tasks[args];
    if (task == null || task.state != TaskState.available) {
      socket.emit('joinTaskResponse', {'error': 'not-available'});
      return;
    }
    if (task.participants.length < task.peopleCount) {
      socket.join('${task.id}');
      task.participants.add(socket.id);
      print('$player joined task ${task.name}');
    }
    if (task.participants.length == task.peopleCount) {
      task.state = TaskState.inProgress;
      _taskChanged(task);
      print('Task "${task.name}" started');
    }
    socket.emit('joinTaskResponse', task.toJson());
  }

  void _taskChanged(Task task) {
    broadcast('taskChange', task.toJson());
  }

  void _createPlanet() {
    game.planets.add(Planet(
      'CP-${game.planets.length}',
      Duration(minutes: 10),
    ));
    game.planet.addTasks([
      Task(TaskType.test, 'do sth', 1, .2),
    ]);
  }
}
