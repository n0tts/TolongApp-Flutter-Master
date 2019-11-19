import 'dart:async';

import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/models/schedule.dart';
import 'package:TolongAppEmployer/repositories/schedules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleBloc extends BlocBase {
  ScheduleBloc();

  final _schedulesController = StreamController<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get getSchedules =>
      _schedulesController.stream;

  Sink<List<DocumentSnapshot>> get _setSchedules => _schedulesController.sink;

  Future<bool> updateSchedule(
      DocumentSnapshot snapshot, Schedule schedule) async {
    bool updated = await schedules.updateSchedule(snapshot, schedule);
    return updated;
  }

  void getLatestSchedule(String uid) {
    schedules.getSchedulesSnapshotByReference(uid).listen((snapshot) {
      getLatest3DaysSchedule(snapshot.documents);
    });
  }

  void getLatest3DaysSchedule(List<DocumentSnapshot> schedules) {
    schedules.takeWhile((document) {
      var today = new DateTime.now();
      var dayAfterTomorrow = today.add(new Duration(days: 2));
      DateTime date = document['dates'];
      return date.isAfter(today) && date.isBefore(dayAfterTomorrow);
    });
    _setSchedules.add(schedules);
  }

  @override
  void dispose() {
    print('disposing schedulesController');
    _schedulesController.close();
  }
}
