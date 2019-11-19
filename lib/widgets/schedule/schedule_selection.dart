import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/app_bloc.dart';
import 'package:TolongAppEmployer/blocs/schedule_bloc.dart';
import 'package:TolongAppEmployer/models/schedule.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/utils/schedule_utils.dart';
import 'package:TolongAppEmployer/widgets/task/task_creator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleSelector extends StatefulWidget {
  final String uid;
  final String hid;
  final String helperName;

  ScheduleSelector({Key key, this.uid, this.hid, this.helperName})
      : super(key: key);

  @override
  _ScheduleSelectorState createState() => _ScheduleSelectorState();
}

class _ScheduleSelectorState extends State<ScheduleSelector> {
  ScheduleBloc _scheduleBloc = new ScheduleBloc();
  List<Schedule> _selectedSchedule;
  num selectedTotal;
  num selectedDuration;
  Task task;
  Map<String, List<Schedule>> helperSchedules;
  bool hasSchedule;
  List<Widget> schedulesWidget;
  String _todayDate = new DateFormat('dd-MM-yyyy').format(new DateTime.now());
  String _tomorrowDate = new DateFormat('dd-MM-yyyy')
      .format(new DateTime.now().add(new Duration(days: 1)));
  String _dayAfterTomorrowDate = new DateFormat('dd-MM-yyyy')
      .format(new DateTime.now().add(new Duration(days: 2)));

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedSchedule = new List();
      selectedTotal = 0;
      selectedDuration = 0;
      helperSchedules = new Map();
      hasSchedule = false;
    });
    setUpScheduleList();
  }

  void setUpScheduleList() {
    _scheduleBloc.getLatestSchedule(widget.hid);
    _scheduleBloc.getSchedules.listen((snapshot) {
      if (this.mounted) {
        setState(() {
          if (snapshot.isNotEmpty) {
            helperSchedules.clear();
            helperSchedules = scheduleUtils.getLatestSchedules(snapshot);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    print('disposing selection');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_buildSchedules()],
    );
  }

  Widget _buildSchedules() {
    if (helperSchedules.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Text(
          'Helper currently not available for hire',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildScheduleList(_todayDate, 'today'),
        _buildScheduleList(_tomorrowDate, 'tomorrow'),
        _buildScheduleList(_dayAfterTomorrowDate, 'day after tomorrow'),
        _buildTaskCreator()
      ],
    );
  }

  Widget _buildScheduleList(String date, String title) {
    if (!helperSchedules.keys.contains(date)) {
      return SizedBox(
        height: 0.0,
      );
    }
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _buildScheduleListItem(
          helperSchedules.putIfAbsent(date, () {}), title),
    );
  }

  Widget _buildTaskCreator() {
    if (_selectedSchedule.isEmpty) {
      return SizedBox(
        height: 0.0,
      );
    }
    return Column(
      children: <Widget>[
        Divider(
          color: Colors.grey,
          height: 2.0,
        ),
        new TaskCreator(
            total: selectedTotal,
            duration: selectedDuration,
            task: task,
            hid: widget.hid,
            uid: widget.uid,
            helperName: widget.helperName),
      ],
    );
  }

  List<Widget> _buildScheduleListItem(List<Schedule> schedule, String title) {
    List<Widget> tiles = [];
    tiles.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
    schedule.forEach((skill) => {
          tiles.add(Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: _selectedSchedule.contains(skill)
                      ? Colors.green
                      : Colors.grey[300]),
              child: new CheckboxListTile(
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    value
                        ? _selectedSchedule.add(skill)
                        : _selectedSchedule.remove(skill);
                  });
                  _estimateTaskPrice();
                },
                value: _selectedSchedule.contains(skill),
                title: Text(
                  skill.range +
                      ' : ' +
                      skill.duration.toStringAsFixed(2) +
                      ' Hours',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ))
        });

    return tiles;
  }

  void _estimateTaskPrice() {
    setState(() {
      var initialValue = 0;
      _selectedSchedule.forEach((schedule) {
        initialValue += schedule.duration;
      });
      print('selecte schedule length ' + _selectedSchedule.length.toString());
      print('initial value ' + initialValue.toString());
      selectedDuration = initialValue;
      selectedTotal = initialValue * 8;
    });
  }
}
