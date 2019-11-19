import 'package:TolongAppEmployer/blocs/employers_bloc.dart';
import 'package:TolongAppEmployer/models/employer.dart';
import 'package:TolongAppEmployer/services/authentication.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final BaseAuth auth;

  const SignUpPage({Key key, this.auth}) : super(key: key);

  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  final _bloc = EmployerBloc();
  String _firstName;
  String _lastName;
  String _icNo;
  String _email;
  String _password;
  String _displayName;
  String _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool _validateAndSave() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    void _showLoginError() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Unable to sign up"),
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
    void _validateAndSubmit() async {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      if (_validateAndSave()) {
        // trigger function to register user
        await widget.auth.signUp(_email, _password, _displayName).then((uid) {
          if (uid.isNotEmpty) {
            _bloc.addEmployer(Employer(_firstName, _lastName, _email, uid));
          }

          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }).catchError((error) {
          print('Error: $error');
          setState(() {
            _isLoading = false;
            _errorMessage = error.message;
          });
          _showLoginError();
        });
        // if success, navigate to login page

      } else {
        _isLoading = false;
      }
    }

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

    final firstName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'First Name',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value.isEmpty ? 'Please enter first name' : null,
      onSaved: (value) => _firstName = value,
    );

    final lastName = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Last Name',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value.isEmpty ? 'Please enter last name' : null,
      onSaved: (value) => _lastName = value,
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

    final signUpButton = Container(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: _validateAndSubmit,
        padding: EdgeInsets.all(12),
        color: Color.fromARGB(255, 106, 187, 67),
        child: Text('SIGNUP', style: TextStyle(color: Colors.white)),
      ),
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

    // Check if form is valid before perform login or signup
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
                          firstName,
                          SizedBox(height: 15.0),
                          lastName,
                          SizedBox(height: 15.0),
                          email,
                          SizedBox(height: 15.0),
                          password,
                          SizedBox(height: 15.0),
                          signUpButton,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _showCircularProgress()
          ],
        ));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
