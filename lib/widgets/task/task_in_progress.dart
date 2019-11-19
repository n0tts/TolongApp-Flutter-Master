import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/app_bloc.dart';
import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/widgets/task/task_card_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskInProgressList extends StatefulWidget {
  final String uid;

  TaskInProgressList({Key key, this.uid}) : super(key: key);

  _TaskInProgressListState createState() => _TaskInProgressListState();
}

class _TaskInProgressListState extends State<TaskInProgressList> {
  TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    _taskBloc = appBloc.taskBloc;
    _taskBloc.getTasksById(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _taskBloc.getInProgressTasks,
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return new TaskCardList(tasks: snapshot.data);
        } else {
          return Container(
            height: null,
            child: Center(
              child: Text('Task in progress is empty'),
            ),
          );
        }
      },
    );
  }
}
