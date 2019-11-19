import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerRepository {
  final CollectionReference collection =
      Firestore.instance.collection('helpers');

  Stream<QuerySnapshot> getAll() {
    return collection.snapshots();
  }

  Stream<DocumentSnapshot> getById(String uid) {
    return collection.document(uid).snapshots();
  }
}

WorkerRepository workers = WorkerRepository();
