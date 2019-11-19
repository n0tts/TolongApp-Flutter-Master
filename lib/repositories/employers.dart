import 'package:TolongAppEmployer/models/employer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference collection =
    Firestore.instance.collection('employers');

class EmployerRepository {
  EmployerRepository();

  Stream<DocumentSnapshot> getEmployerById(String uid) {
    return collection.document(uid).snapshots();
  }

  Future<Employer> getEmployerByReference(String uid) async {
    QuerySnapshot snapshot = await collection.where('reference', isEqualTo: uid).getDocuments();
    return Employer.fromSnapshot(snapshot.documents.first);
  }

  Future<void> updateEmployer(DocumentSnapshot snapshot) async {
    await collection
        .document(snapshot.documentID)
        .updateData(Employer.fromSnapshot(snapshot).toMap());
  }

  Future<DocumentReference> addEmployer(Employer employer) async {
    var reference = await collection.add(employer.toMap());
    return reference;
  }

  Future<String> getEmployerByEmail(String email) async {
    return await collection
        .where('email', isEqualTo: email)
        .getDocuments()
        .then((data) {
      if (data.documents.isNotEmpty) {
        if (data.documents.single.exists) {
          return data.documents.single.documentID;
        }
      }
    });
  }
}

EmployerRepository employers = new EmployerRepository();
