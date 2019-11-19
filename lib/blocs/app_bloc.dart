import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/employers_bloc.dart';
import 'package:TolongAppEmployer/blocs/schedule_bloc.dart';
import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/blocs/worker_bloc.dart';

class AppBloc extends BlocBase {
  EmployerBloc _employerBloc;
  ScheduleBloc _scheduleBloc;
  TaskBloc _taskBloc;
  WorkerBloc _workerBloc;

  AppBloc()
      : _employerBloc = EmployerBloc(),
        _scheduleBloc = ScheduleBloc(),
        _taskBloc = TaskBloc(),
        _workerBloc = WorkerBloc();

  EmployerBloc get employerBloc => _employerBloc;
  ScheduleBloc get scheduleBloc => _scheduleBloc;
  TaskBloc get taskBloc => _taskBloc;
  WorkerBloc get workerBloc => _workerBloc;

  @override
  void dispose() {
    _employerBloc.dispose();
    _taskBloc.dispose();
    _scheduleBloc.dispose();
    _workerBloc.dispose();
  }
}
