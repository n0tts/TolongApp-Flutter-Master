import 'package:TolongAppEmployer/widgets/task/task_history.dart';
import 'package:TolongAppEmployer/widgets/task/task_in_progress.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  final String uid;

  const TasksScreen({Key key, this.uid}) : super(key: key);
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        // The number of tabs / content sections we need to display
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }) ,
            bottom: TabBar(
              tabs: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Center(child: Text('In Progress'))),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Center(child: Text('History'))),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              new TaskInProgressList(uid: widget.uid,),
              new TaskHistoryList(uid: widget.uid,),
            ],
          ),
        ));
  }
}
