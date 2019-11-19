import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/models/worker.dart';
import 'package:TolongAppEmployer/utils/list_utils.dart';
import 'package:TolongAppEmployer/widgets/helper/helper_profile_section.dart';
import 'package:TolongAppEmployer/widgets/task/task_list_builder.dart';
import 'package:flutter/material.dart';

class HelperProfileBuilder extends StatefulWidget {
  final Worker worker;
  final String hid;

  HelperProfileBuilder({Key key, this.worker, this.hid}) : super(key: key);

  @override
  _HelperProfileBuilderState createState() => _HelperProfileBuilderState();
}

class _HelperProfileBuilderState extends State<HelperProfileBuilder> {
  final _tasksBloc = new TaskBloc();
  List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HelperProfileSection(
                title: 'Full Name',
                description:
                    widget.worker.firstName + ' ' + widget.worker.lastName,
              ),
              HelperProfileSection(
                title: 'Age',
                description: widget.worker.age.toString(),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HelperProfileSection(
                title: 'Academic Qualifications',
                description: ListUtils.parseListToString(
                    widget.worker.academicQualification),
              ),
              HelperProfileSection(
                title: 'Other Qualification',
                description: ListUtils.parseListToString(
                    widget.worker.otherQualification),
              )
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          _buildTaskList()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      this.tasks = new List();
    });
    setUpTaskList();
  }

  Widget _buildTaskList() {
    if (this.tasks.isEmpty) {
      return SizedBox(
        height: 0.0,
      );
    }
    return new TaskListBuilder(
      tasks: this.tasks,
    );
  }

  void setUpTaskList() {
    _tasksBloc.getTasksByHelperId(widget.hid);
    _tasksBloc.getTasks.listen((tasks) {
      setState(() {
        this.tasks?.clear();
        this.tasks = tasks.documents
            .where((task) => task.data['status'] == 'completed')
            .take(3)
            .map((snapshot) => Task.fromSnapshot(snapshot))
            .toList();
      });

      print('builder task ' + this.tasks.length.toString());
    });
  }

  @override
  void dispose() {
    _tasksBloc.dispose();
    super.dispose();
  }
}
