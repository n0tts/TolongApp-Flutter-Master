import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/widgets/task/task_list.dart';
import 'package:flutter/material.dart';

class TaskListBuilder extends StatelessWidget {
  final List<Task> tasks;

  TaskListBuilder({Key key, this.tasks}) : super(key: key);

  List<Widget> _buildTaskList() {
    List<Widget> rows = new List();
    if (this.tasks.isNotEmpty) {
      rows.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[Text('Last ${this.tasks.length} Tasks')],
        ),
      ));

      this.tasks.forEach((task) {
        rows.add(new TaskList(
          task: task,
        ));
      });
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildTaskList(),
    );
  }
}
