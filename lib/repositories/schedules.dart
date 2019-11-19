import 'package:TolongAppEmployer/models/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleRepository {
  final CollectionReference collection =
      Firestore.instance.collection('schedules');
  
  Stream<QuerySnapshot> getSchedulesSnapshotByReference(String uid) {
    return collection.where('reference', isEqualTo: uid).snapshots();
  }

  Future<String> addSchedule(Schedule schedule) async {
    DocumentReference reference = await collection.add(schedule.toMap());
    print('Successfully created new schedule : ' + reference.documentID);
    return reference.documentID;
  }


  Future<bool> updateSchedule(
      DocumentSnapshot snapshot, Schedule schedule) async {
    bool updated = false;
    await collection
        .document(snapshot.documentID)
        .updateData(schedule.toMap())
        .then((success) {
      updated = true;
    }).catchError((error) {
      print(error);
    });

    return updated;
  }

  Future<List<DocumentSnapshot>> getSchedulesByReference(String uid) async {
    var documents = await collection.where('reference', isEqualTo: uid).getDocuments();
    return documents.documents;
  }

  void deleteSchedule(DocumentSnapshot snapshot) async {
    await collection.document(snapshot.documentID).delete().then((complete) {
      print('Successfully remove schedule : ' + snapshot.documentID);
    }).catchError((error) {
      print('Failed to remove schedule : ' + error.toString());
    });
  }
}

ScheduleRepository schedules = ScheduleRepository();
