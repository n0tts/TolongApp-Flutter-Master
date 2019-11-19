import 'dart:async';

import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/repositories/workers.dart';
import 'package:TolongAppEmployer/services/geolocator.dart';
import 'package:TolongAppEmployer/utils/schedule_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TolongAppEmployer/repositories/schedules.dart';

class WorkerBloc extends BlocBase {
  WorkerBloc() {
    workers.getAll().listen((snapshot) {
      filterByDistance(snapshot);
    });
  }

  final _workersController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get getWorkers => _workersController.stream;

  Sink<List<DocumentSnapshot>> get _setWorkers => _workersController.sink;

  void filterByDistance(QuerySnapshot snapshot) async {
    var position = await geoLocator.getCurrentPosition();
    print('awaiting location completed');
    var workers =
        await geoLocator.getMatchedDistance(position, snapshot.documents, 10);
    print('check worker location completed');
    updateAvailability(workers).then((documents){
      print('update worker availability completed');
      workers = documents;
      workers.sort((curr, next) => curr.data['availability'].hashCode
          .compareTo(next.data['availability'].hashCode));
      _setWorkers.add(workers);
    });

    _setWorkers.add(workers);
  }

  Future<List<DocumentSnapshot>> updateAvailability(List<DocumentSnapshot> workers) async {
    for(var worker in workers){
      var list = await schedules.getSchedulesByReference(worker.documentID);
      var latestSchedules = scheduleUtils.getLatestSchedules(list);
      worker.data['availability'] = worker.data['availability']
          ? latestSchedules.isNotEmpty
          : worker.data['availability'];
    }

    return workers;
  }

  @override
  void dispose() {
    _workersController.close();
  }
}
