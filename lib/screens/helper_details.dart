import 'package:TolongAppEmployer/blocs/schedule_bloc.dart';
import 'package:TolongAppEmployer/utils/schedule_utils.dart';
import 'package:TolongAppEmployer/widgets/helper/helper_basic.dart';
import 'package:TolongAppEmployer/widgets/helper/helper_profile_builder.dart';
import 'package:TolongAppEmployer/widgets/schedule/schedule_selection.dart';
import 'package:TolongAppEmployer/models/worker.dart';
import 'package:flutter/material.dart';

class HelperDetailScreen extends StatefulWidget {
  final Worker worker;
  final bool showSchedule;
  final String uid;
  final String hid;
  HelperDetailScreen(
      {Key key, this.showSchedule, this.worker, this.uid, this.hid})
      : super(key: key);
  @override
  _HelperDetailScreenState createState() => _HelperDetailScreenState();
}

class _HelperDetailScreenState extends State<HelperDetailScreen> {
  bool _showSchedule;
  Worker _worker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_worker.firstName + ' ' + _worker.lastName),
      ),
      body: Container(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            HelperBasicDetail(
              worker: _worker,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showSchedule = true;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('View Schedule')
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _showSchedule = false;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.verified_user,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('View Full Profile')
                        ],
                      )),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 2.0,
            ),
            _showSchedule
                ? new ScheduleSelector(
                    hid: widget.hid,
                    uid: widget.uid,
                    helperName:
                        widget.worker.firstName + ' ' + widget.worker.lastName)
                : new HelperProfileBuilder(worker: _worker, hid: widget.hid),
          ],
        ),
      ))),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _showSchedule = widget.showSchedule;
      _worker = widget.worker;
    });
  }

  @override
  void dispose() {
    print('disposing helper details');
    super.dispose();
  }
}
