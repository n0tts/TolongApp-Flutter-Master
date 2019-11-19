import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/app_bloc.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key key}) : super(key: key);

  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    return Container();
  }
}
