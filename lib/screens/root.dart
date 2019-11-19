import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/screens/home.dart';
import 'package:TolongAppEmployer/screens/login.dart';
import 'package:TolongAppEmployer/services/authentication.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _displayName = '';
  bool _isAnonymous = true;

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          onSignedInAnonymous: _onSignedInAnonymous,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomeScreen(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            isAnonymous: _isAnonymous,
            displayName: _displayName,
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          print(_userId);
          _displayName = user.displayName;
          print('root init');
          print(user.displayName);
          _isAnonymous = user.isAnonymous;
          authStatus = AuthStatus.LOGGED_IN;
        }else{
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }
      });
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _isAnonymous = user.isAnonymous;
        _displayName = user.displayName;
        print(_displayName);
        authStatus = AuthStatus.LOGGED_IN;
      });
      print('anonymous user ${user.isAnonymous.toString()} ');
    });
  }

  void _onSignedInAnonymous() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _isAnonymous = user.isAnonymous;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }
}
