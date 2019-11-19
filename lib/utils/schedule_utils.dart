import 'package:TolongAppEmployer/models/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ScheduleUtils {
  String _todayDate = new DateFormat('dd-MM-yyyy').format(new DateTime.now());
  String _tomorrowDate = new DateFormat('dd-MM-yyyy')
      .format(new DateTime.now().add(new Duration(days: 1)));
  String _dayAfterTomorrowDate = new DateFormat('dd-MM-yyyy')
      .format(new DateTime.now().add(new Duration(days: 2)));
  List<Schedule> _todaySchedule = new List();
  List<Schedule> _tomorrowSchedule = new List();
  List<Schedule> _dayAfterTomorrowSchedule = new List();
  Map<String, List<Schedule>> _fullSchedule = new Map();

  ScheduleUtils();

  Map<String, List<Schedule>> getLatestSchedules(List<DocumentSnapshot> documents) {
    _todaySchedule.clear();
    _tomorrowSchedule.clear();
    _dayAfterTomorrowSchedule.clear();
    _fullSchedule.clear();
    if (documents.isNotEmpty) {
      documents.forEach((schedule) {
        var data = Schedule.fromSnapshot(schedule);
        var date = new DateFormat('dd-MM-yyyy').format(data.dates);
        if (date == _todayDate) {
          _todaySchedule.add(data);
        }

        if (date == _tomorrowDate) {
          _tomorrowSchedule.add(data);
        }

        if (date == _dayAfterTomorrowDate) {
          _dayAfterTomorrowSchedule.add(data);
        }
      });

      if (_todaySchedule.isNotEmpty) {
        _fullSchedule.putIfAbsent(_todayDate, () => _todaySchedule);
      }
      if (_tomorrowSchedule.isNotEmpty) {
        _fullSchedule.putIfAbsent(_tomorrowDate, () => _tomorrowSchedule);
      }
      if (_dayAfterTomorrowSchedule.isNotEmpty) {
        _fullSchedule.putIfAbsent(
            _dayAfterTomorrowDate, () => _dayAfterTomorrowSchedule);
      }
    }

    return _fullSchedule;
  }
}

ScheduleUtils scheduleUtils = new ScheduleUtils();
