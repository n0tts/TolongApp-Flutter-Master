import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/app_bloc.dart';
import 'package:TolongAppEmployer/screens/helper_details.dart';
import 'package:TolongAppEmployer/screens/home.dart';
import 'package:TolongAppEmployer/screens/root.dart';
import 'package:TolongAppEmployer/screens/tasks.dart';
import 'package:TolongAppEmployer/screens/test.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        title: 'TolongApp User',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 225, 109, 69),
        ),
        home: RootPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new RootPage(),
          '/tasks': (BuildContext context) => new TasksScreen(),
          '/detail': (BuildContext context) => new HelperDetailScreen(),
        },
      ),
    );
  }
}
