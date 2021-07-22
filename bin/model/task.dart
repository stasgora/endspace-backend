import 'package:enum_to_string/enum_to_string.dart';
import 'package:meta/meta.dart';

enum TaskType {
  test
}

enum TaskState {
  available, inProgress, completed, failed
}

class Task with Counted {
  final TaskType type;
  final String name;
  List<String> participants = [];
  final int peopleCount;
  final double energyGain;
  TaskState state = TaskState.available;

  Task(this.type, this.name, this.peopleCount, this.energyGain) {
    assignID();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': EnumToString.convertToString(type),
    'state': EnumToString.convertToString(state),
    'participants': participants.length,
    'name': name,
  };
}

mixin Counted {
  static int _counter = 0;
  late int id;

  @protected
  void assignID() => id = _counter++;
}
