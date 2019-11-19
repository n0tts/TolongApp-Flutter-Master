import 'dart:async';

import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  final num duration;
  final num price;
  final String hid;
  final String uid;
  final String helperName;

  CreateTaskScreen({
    Key key,
    this.duration,
    this.price,
    this.hid,
    this.uid,
    this.helperName,
  }) : super(key: key);

  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _tasksBloc = new TaskBloc();
  String _title;
  String _description;
  String _address;

  @override
  Widget build(BuildContext context) {
    final title = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: 'What is the job position?',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      validator: (value) =>
          value.trim().isEmpty ? 'Please assign position for the job' : null,
      onSaved: (value) => _title = value,
    );

    final description = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: 'Description about the job',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      validator: (value) =>
          value.trim().isEmpty ? 'Please describe about the job' : null,
      onSaved: (value) => _description = value,
    );

    final address = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        hintText: 'Where is the workplace?',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      validator: (value) =>
          value.trim().isEmpty ? 'Please insert an address' : null,
      onSaved: (value) => _address = value,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Helper'),
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Job Position',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                  ),
                  title,
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Description',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                  ),
                  description,
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                  ),
                  address,
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Choosen Hours: ' +
                              widget.duration.toStringAsFixed(2)),
                        ),
                        SizedBox(
                          height: 26.0,
                        ),
                        Text('Total Payment'),
                        Text(
                          'RM ' + widget.price.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
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
                              _validateAndSubmit();
                            },
                            color: Color.fromARGB(255, 106, 187, 67),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('SEND REQUEST',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
                      ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      _createNewTask();
    }
  }

  void _createNewTask() async {
    Task task = new Task(
        _title,
        _description,
        _address,
        widget.uid,
        widget.hid,
        widget.duration.toString(),
        widget.price.toStringAsFixed(2),
        widget.helperName,
        'new',
        false,
        false);
    var reference = await _tasksBloc.addTask(task);
    if (reference != null) {
      print(reference.documentID);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
                child: new DialogContent(
              uid: reference,
              task: task,
            ));
          });
    }
  }

  @override
  void dispose() {
    _tasksBloc.dispose();
    super.dispose();
  }
}

class DialogContent extends StatefulWidget {
  final DocumentReference uid;
  final Task task;

  DialogContent({Key key, this.uid, this.task}) : super(key: key);

  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  final _taskBloc = TaskBloc();
  Timer _timer;
  int _start = 60;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
                _cancelTask();
              } else {
                _start = _start - 1;
              }
            }));
  }

  void _cancelTask() async {
    await _taskBloc.updateTask(widget.uid, 'no-reply');
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Pending reply from helper'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Text(
              _start.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
          )
        ],
      ),
    );
  }
}
