import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/screens/create_task.dart';
import 'package:flutter/material.dart';

class TaskCreator extends StatefulWidget {
  final num total;
  final num duration;
  final String hid;
  final String uid;
  final Task task;
  final String helperName;

  TaskCreator(
      {Key key,
      this.total,
      this.duration,
      this.task,
      this.uid,
      this.hid,
      this.helperName})
      : super(key: key);

  _TaskCreatorState createState() => _TaskCreatorState();
}

class _TaskCreatorState extends State<TaskCreator> {
  void _createNewTask() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateTaskScreen(
                  duration: widget.duration,
                  price: widget.total,
                  hid: widget.hid,
                  uid: widget.uid,
                  helperName: widget.helperName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    print('creator being rebuild');
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Choosen Hours: ' + widget.duration.toStringAsFixed(2)),
      ),
      SizedBox(
        height: 26.0,
      ),
      Text('Total Payment'),
      Text(
        'RM ' + widget.total.toStringAsFixed(2),
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 16.0,
      ),
      Container(
        width: double.infinity,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () {
            _createNewTask();
          },
          padding: EdgeInsets.all(12),
          color: Color.fromARGB(255, 106, 187, 67),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('MAKE A REQUEST', style: TextStyle(color: Colors.white)),
          ),
        ),
      )
    ]);
  }
}
