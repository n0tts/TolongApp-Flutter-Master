import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/app_bloc.dart';
import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/widgets/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class TaskCardList extends StatefulWidget {
  final List<DocumentSnapshot> tasks;

  TaskCardList({Key key, this.tasks}) : super(key: key);

  _TaskCardListState createState() => _TaskCardListState();
}

class _TaskCardListState extends State<TaskCardList> {
  TaskBloc _taskBloc;
  List<Task> _tasks;
  double _rating;

  @override
  void initState() {
    super.initState();
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    _taskBloc = appBloc.taskBloc;
    setState(() {
      _tasks =
          widget.tasks.map((snapshot) => Task.fromSnapshot(snapshot)).toList();
    });
    setState(() {
      _rating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build card list');
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (BuildContext context, int index) {
        Task _task = _tasks[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          elevation: 5.0,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _task.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _task.description,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                _task.location,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text('Status: ' + _task.status.toUpperCase()),
                            ],
                          ),
                        ),
                        _task.status == 'in-progress'
                            ? RaisedButton(
                                onPressed: () {
                                  _taskBloc.updateTask(
                                      widget.tasks[index].reference,
                                      'completed');
                                },
                                child: Text(
                                  'Mark Complete',
                                ))
                            : SizedBox()
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Helper: ' + _task.helperName),
                      Text('Price: ' + _task.price)
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
