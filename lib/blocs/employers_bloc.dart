import 'dart:async';

import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/models/employer.dart';
import 'package:TolongAppEmployer/repositories/employers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployerBloc extends BlocBase {
  EmployerBloc();

  final _employerController = StreamController<DocumentSnapshot>.broadcast();
  Stream<DocumentSnapshot> get getEmployer => _employerController.stream;
  Sink<DocumentSnapshot> get _setEmployer => _employerController.sink;

  void getEmployerById(String uid) {
    employers.getEmployerById(uid).listen((snapshot) {
      _setEmployer.add(snapshot);
    });
  }

  Future<void> getEmployerByEmail(String email) async {
    String referenceId = await employers.getEmployerByEmail(email);
    this.getEmployerById(referenceId);
  }

  Future<void> updateEmployer(DocumentSnapshot snapshot) async {
    await employers.updateEmployer(snapshot);
  }

  Future<void> addEmployer(Employer employer) async {
    DocumentReference reference = await employers.addEmployer(employer);
    this.getEmployerById(reference.documentID);
  }

  Future<String> getEmployerName(String uid) async {
    var employer = await employers.getEmployerByReference(uid);
    return employer.firstName + ' ' + employer.lastName;
  }

  @override
  void dispose() {
    _employerController.close();
  }
}
