import 'package:enum_to_string/enum_to_string.dart';
import 'package:meta/meta.dart';

enum TaskType {
  test
}

enum TaskState {
  available, inProgress, completed, failed
}

extension TaskFinished on TaskState {
  bool get finished => this == TaskState.completed || this == TaskState.failed;
}

class Task with Counted {
  final TaskType type;
  final String name;
  List<String> players = [];
  final int playersNeeded;
  final double energyGain;
  TaskState state = TaskState.available;

  Task(this.type, this.name, this.playersNeeded, this.energyGain) {
    assignID();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': EnumToString.convertToString(type),
    'state': EnumToString.convertToString(state),
    'players': players.length,
    'playersNeeded': playersNeeded,
    'name': name,
  };
}

mixin Counted {
  static int _counter = 0;
  late int id;

  @protected
  void assignID() => id = _counter++;
}
