import 'dart:async';

import 'package:TolongAppEmployer/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference collection = Firestore.instance.collection('tasks');

class TaskRepository {
  static final TaskRepository _instance = new TaskRepository.internal();

  factory TaskRepository() => _instance;

  TaskRepository.internal();

  Stream<QuerySnapshot> getTaskList(String uid) {
    Stream<QuerySnapshot> snapshots =
        collection.where('reference', isEqualTo: uid).snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getTaskListByHelperId(String uid) {
    Stream<QuerySnapshot> snapshots =
        collection.where('worker', isEqualTo: uid).snapshots();
    return snapshots;
  }

  Future<DocumentReference> addTask(Task task) async {
    var reference = await collection.add(task.toMap());
    return reference;
  }

  Future<void> updateTaskStatus(
      DocumentReference reference, String status) async {
    await Firestore.instance.runTransaction((transaction) {
      return transaction.get(reference).then((snapshot) {
        if (snapshot.data['status'] != status) {
          return transaction.update(reference, {'status': status});
        }
      });
    }).then((data) {
      print('successfuly update task ');
    }).catchError((error) {
      print('failed update task ' + error.message.toString());
    });
  }
}

TaskRepository tasks = new TaskRepository();
