import 'package:TolongAppEmployer/blocs/worker_bloc.dart';
import 'package:TolongAppEmployer/screens/sign_up.dart';
import 'package:TolongAppEmployer/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final BaseAuth auth;

  final VoidCallback onSignedIn;
  final VoidCallback onSignedInAnonymous;
  LoginPage({this.auth, this.onSignedIn, this.onSignedInAnonymous});
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Main Color
  // HTML code:	#FE7641
  // RGB code:	R: 225 G: 109 B: 69

  // Secondary Color
  // HTML code:	#6ABB43
  // RGB code:	R: 106 G: 187 B: 67
  final _formKey = new GlobalKey<FormState>();
  final _workerBloc = WorkerBloc();
  List<DocumentSnapshot> _workers;
  String _email;
  String _password;
  String _errorMessage;
  bool _isLoading;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value,
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value,
    );

    final loginButton = Container(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: _validateAndSubmit,
        padding: EdgeInsets.all(12),
        color: Color.fromARGB(255, 106, 187, 67),
        child: Text('LOGIN', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot Password',
        style: TextStyle(
            color: Colors.white, decoration: TextDecoration.underline),
      ),
      onPressed: () {},
    );

    final signInAnonymous = FlatButton(
      child: Text(
        'Sign in as Guest',
        style: TextStyle(
            color: Colors.white, decoration: TextDecoration.underline),
      ),
      onPressed: () {
        _signInAsAnonymous();
      },
    );

    final signUpLabel = FlatButton(
      child: Row(
        children: <Widget>[
          Text(
            'New Here? ',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Signup',
            style: TextStyle(
                color: Colors.white, decoration: TextDecoration.underline),
          )
        ],
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpPage(
                      auth: widget.auth,
                    )));
      },
    );

    Widget _showCircularProgress() {
      if (_isLoading) {
        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.green,
        ));
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 225, 109, 69),
        body: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: 'hero',
                            child: CircleAvatar(
                                radius: 80,
                                child: Image(
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                      'assets/images/logos/logo.png'),
                                )),
                          ),
                          SizedBox(height: 30.0),
                          email,
                          SizedBox(height: 10.0),
                          password,
                          SizedBox(height: 24.0),
                          loginButton,
                          SizedBox(
                            height: 24.0,
                          ),
                          signInAnonymous
                        ],
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[forgotLabel, signUpLabel],
                    )
                  ],
                ),
              ),
            ),
            _showCircularProgress()
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _workers = new List();

    _workerBloc.getWorkers.listen((querySnapshot) {
      setState(() {
        _workers = querySnapshot;
      });
    });
  }

  @override
  void dispose() {
    _workerBloc.dispose();
    super.dispose();
  }

  void _showLoginError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Unable to sign in"),
          content: new Text(_errorMessage),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Try Again"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Perform login or signup
  void _signInAsAnonymous() async {
    String userId = "";
    userId = await widget.auth.signInAnonymous();
    print('Signed in anonymous: $userId');
    widget.onSignedInAnonymous();
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      if (!_isEmailBelongToWorker(_email)) {
        String userId = "";
        try {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');

          setState(() {
            _isLoading = false;
          });

          if (userId.length > 0 && userId != null) {
            widget.onSignedIn();
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            _errorMessage = e.message;
          });
          _showLoginError();
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Email has been registered as helper account';
        });
        _showLoginError();
      }
    } else {
      _isLoading = false;
    }
  }

  bool _isEmailBelongToWorker(String email) {
    List<DocumentSnapshot> foundWorkerWithEmail = _workers
        .where(
            (snapshot) => snapshot.data['email'] == email.toLowerCase().trim())
        .toList();

    return foundWorkerWithEmail.isNotEmpty;
  }
}
