import 'task.dart';

class Planet {
  final String name;
  final DateTime endTime;
  Map<int, Task> tasks = <int, Task>{};

  Planet(this.name, Duration time)
      : endTime = DateTime.now().add(Duration(minutes: 10));

  void addTasks(List<Task> list) {
    list.forEach((task) => tasks[task.id] = task);
  }
}
