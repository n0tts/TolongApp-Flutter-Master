import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference helperCollection =
    Firestore.instance.collection('helpers');

class HelperService {
  static final HelperService _instance = new HelperService.internal();

  factory HelperService() => _instance;

  HelperService.internal();

  Stream<QuerySnapshot> getHelperList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = helperCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Stream<QuerySnapshot> getHelperListByAvailability(
      bool isAvailable, String category) {
    Stream<QuerySnapshot> snapshots = helperCollection
        .reference()
        .where('availability', isEqualTo: isAvailable)
        .where('category', isEqualTo: category)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getHelperListByCategory(String category) {
    Stream<QuerySnapshot> snapshots = helperCollection
        .reference()
        .where('category', isEqualTo: category)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getHelperListByName(String name) {
    Stream<QuerySnapshot> snapshots = helperCollection
        .reference()
        .where('firstName', isGreaterThanOrEqualTo: name)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getHelperListByRating(int rating, String category) {
    Stream<QuerySnapshot> snapshots = helperCollection
        .reference()
        .where('rating', isEqualTo: rating)
        .where('category', isEqualTo: category)
        .snapshots();

    return snapshots;
  }
}
