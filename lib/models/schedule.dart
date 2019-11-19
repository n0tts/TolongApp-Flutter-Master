import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  String _reference;
  DateTime _dates;
  num _duration;
  String _range;

  Schedule(
    this._reference,
    this._dates,
    this._duration,
    this._range,
  );

  Schedule.fromMap(Map<String, dynamic> map) {
    this._reference = map['reference'];
    this._dates = map['dates'];
    this._duration = map['duration'];
    this._range = map['range'];
  }

  Schedule.map(dynamic json) {
    this._reference = json['reference'];
    this._dates = json['dates'];
    this._duration = json['duration'];
    this._range = json['range'];
  }

  DateTime get dates => _dates;
  num get duration => _duration;
  String get range => _range;
  String get reference => _reference;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['reference'] = _reference;
    map['dates'] = _dates;
    map['duration'] = _duration;
    map['range'] = _range;

    return map;
  }

  Schedule.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}
