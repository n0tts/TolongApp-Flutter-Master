import 'dart:async';

import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/repositories/tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskBloc extends BlocBase {
  TaskBloc();
  String uid;

  final _taskController = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> get getTasks => _taskController.stream;

  Sink<QuerySnapshot> get _setTasks => _taskController.sink;

  final _taskInProgressController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get getInProgressTasks =>
      _taskInProgressController.stream;

  Sink<List<DocumentSnapshot>> get _setInProgressTasks =>
      _taskInProgressController.sink;

  final _taskHistoryController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get getHistoryTasks =>
      _taskHistoryController.stream;

  Sink<List<DocumentSnapshot>> get _setHistoryTasks =>
      _taskHistoryController.sink;

  void getTasksById(String uid) {
    this.uid = uid;
    tasks.getTaskList(uid).listen((tasks) {
      _populateInProgressTasks(tasks);
      _populateHistoryTasks(tasks);
      _setTasks.add(tasks);
    });
  }

  void _populateInProgressTasks(QuerySnapshot snapshot){
    var documents = snapshot.documents;
    var inProgressTasks = documents
        .where((document) => _isInProgressTask(document))
        .toList();
    _setInProgressTasks.add(inProgressTasks.reversed.toList());
  }

  bool _isInProgressTask(DocumentSnapshot document) {
    return document.data['status'] == 'in-progress';
  }

  void _populateHistoryTasks(QuerySnapshot snapshot) {
    var documents = snapshot.documents;
    var historyTasks = documents
        .where((document) => !_isInProgressTask(document))
        .toList();
    _setHistoryTasks.add(historyTasks.reversed.toList());
  }

  void getTasksByHelperId(String uid) {
    tasks.getTaskListByHelperId(uid).listen((tasks) {
      _setTasks.add(tasks);
    });
  }

  Future<DocumentReference> addTask(Task task) async {
    var reference = await tasks.addTask(task);
    return reference;
  }

  Future<void> updateTask(DocumentReference reference, String status) async {
    await tasks.updateTaskStatus(reference, status);
  }

  @override
  void dispose() {
    _taskController.close();
    _taskInProgressController.close();
    _taskHistoryController.close();
  }
}
