import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/screens/root.dart';
import 'package:TolongAppEmployer/screens/tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobRejectedPage extends StatefulWidget {
  final Task task;
  final DocumentReference reference;
  JobRejectedPage({Key key, @required this.task, this.reference})
      : super(key: key);

  _JobRejectedPageState createState() => _JobRejectedPageState();
}

class _JobRejectedPageState extends State<JobRejectedPage> {
  final _taskBloc = TaskBloc();
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('View Task'),
                content: new Text('Do you want to view created task?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () =>  Navigator.popUntil(context, ModalRoute.withName('/')),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/tasks'),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _updateTask();
  }

  void _updateTask() async {
    await _taskBloc.updateTask(widget.reference, 'cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Job Rejected',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0),
                      ),
                      Text(
                        widget.task.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/tasks');
                    },
                    child: Text('View Task'),
                  ),
                ),
              )
            ],
          ),
        ),
        onWillPop: () => _onWillPop());
  }
}
