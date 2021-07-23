import '../model/game.dart';
import '../model/planet.dart';
import '../model/task.dart';
import 'connection.dart';

mixin GameManagement on Connection {
  Game get game => room!;
  String get player => game.players[socket.id]!;
  String get roomID => '${task!.id}';

  void onStartGame(dynamic args) {
    _createPlanet();
    broadcast('gameStarted', game.toJson());
  }

  void onTaskAction(dynamic args) => _finishTask();

  void onJoinTask(dynamic args) {
    var task = game.planet.tasks[args];
    if (task == null || task.state != TaskState.available) {
      socket.emit('joinTaskResponse', {'error': 'not-available'});
      return;
    }
    if (task.players.length < task.playersNeeded) {
      this.task = task;
      socket.join(roomID);
      task.players.add(socket.id);
      print('$player joined task ${task.name}');
    }
    if (task.players.length == task.playersNeeded) {
      task.state = TaskState.inProgress;
      print('Task "${task.name}" started');
    }
    _taskChanged();
    socket.emit('joinTaskResponse', task.toJson());
  }

  void onLeaveTask(dynamic args) {
    if (task == null || task!.state.finished) return;
    task!.players.remove(socket.id);
    if (task!.players.isEmpty) task!.state = TaskState.available;
    socket.leave(roomID, (_) {});
    print('$player left task ${task!.name}');
    _taskChanged();
  }

  void _taskChanged() {
    broadcast('taskChange', task?.toJson());
  }

  void _finishTask() {
    if (task == null) return;
    task?.state = TaskState.completed;
    _taskChanged();
    print('Task "${task?.name}" completed');
    game.energy += task!.energyGain;
    task!.players.forEach((id) {
      context.connections[id]?.socket.leave(roomID, (_) {});
    });
    broadcast('dashboardChange', {'energy': game.energy});
    task = null;
  }

  void _createPlanet() {
    game.planets.add(Planet(
      'CP-${game.planets.length}',
      Duration(minutes: 10),
    ));
    game.planet.addTasks([
      Task(TaskType.test, 'single', 1, .2),
      Task(TaskType.test, 'double', 2, .3),
    ]);
  }
}
