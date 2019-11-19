import 'dart:async';

import 'package:TolongAppEmployer/bloc_provider.dart';
import 'package:TolongAppEmployer/blocs/app_bloc.dart';
import 'package:TolongAppEmployer/blocs/employers_bloc.dart';
import 'package:TolongAppEmployer/blocs/task_bloc.dart';
import 'package:TolongAppEmployer/blocs/worker_bloc.dart';
import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/screens/job_accepted.dart';
import 'package:TolongAppEmployer/screens/job_rejected.dart';
import 'package:TolongAppEmployer/screens/settings.dart';
import 'package:TolongAppEmployer/screens/tasks.dart';
import 'package:TolongAppEmployer/services/authentication.dart';
import 'package:TolongAppEmployer/services/geolocator.dart';
import 'package:TolongAppEmployer/widgets/categories.dart';
import 'package:TolongAppEmployer/widgets/helper/helper_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class HomeScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String displayName;
  final bool isAnonymous;

  const HomeScreen(
      {Key key,
      this.auth,
      this.onSignedOut,
      this.userId,
      this.isAnonymous,
      this.displayName})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GeolocatorService geoService = new GeolocatorService();
  WorkerBloc _bloc = new WorkerBloc();
  EmployerBloc _employerBloc = new EmployerBloc();
  TaskBloc _taskBloc;
  AppBloc appBloc;
  String _displayName;

  AppLifecycleState _notification;
  QuerySnapshot _tasks;
  List<DocumentSnapshot> _currentWorkers;
  List<DocumentSnapshot> _workers;
  List<DocumentSnapshot> _results;

  List<String> promos = new List();
  Position _currentLocation;
  final TextEditingController editingController = new TextEditingController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              child: Image(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/logos/logo.png'),
          )),
        ),
        title: new TextField(
          maxLines: 1,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search by name or place',
              hintStyle: TextStyle(color: Colors.grey[400]),
              contentPadding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
          onSubmitted: onSubmitted,
          controller: editingController,
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        bottom: this._currentWorkers != null
            ? buildPreferredSize(context, widget.isAnonymous,
                this._currentWorkers, widget.userId, _currentLocation)
            : null,
      ),
      endDrawer: Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Center(
                child: Container(
                  width: double.infinity,
                  color: Color.fromARGB(255, 225, 109, 69),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              AssetImage('assets/images/profiles/default.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: widget.isAnonymous
                              ? Text('Welcome Guest')
                              : Text('Welcome ${_displayName}'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                selected: true,
                onTap: () {
                  // This line code will close drawer programatically....
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('My Tasks'),
                onTap: () {
                  // This line code will close drawer programatically....
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TasksScreen(
                                uid: widget.userId,
                              )));
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Signout'),
                onTap: () {
                  _signOut();
                },
              )
            ],
          )),
      body: Material(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 2,
              ),
              CarouselSlider(
                height: MediaQuery.of(context).size.height * 0.2,
                viewportFraction: 1.0,
                aspectRatio: 2.0,
                items: promos.map((promo) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(
                        promo,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 16,
                      ),
                      Text(
                        'HELPER NEARBY WITHIN 10KM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
              StreamBuilder(
                stream: _bloc.getWorkers,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text('Waiting helpers')
                        ],
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data.isEmpty) {
                      return Center(
                          child: Text('There\'s no helper available'));
                    }
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return new HelperCard(
                            hasPermission: widget.isAnonymous ? false : true,
                            snapshot: snapshot.data[index],
                            uid: widget.userId,
                            location: _currentLocation,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appBloc.dispose();
    _taskBloc.dispose();
    _bloc.dispose();
    _employerBloc.dispose();
    print('disposing home');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('init state home triggered');
    WidgetsBinding.instance.addObserver(this);
    appBloc = BlocProvider.of<AppBloc>(context);
    _bloc.getWorkers.listen((documents) {
      print('listening to worker details');
      if (this.mounted) {
        setState(() {
          _currentWorkers = documents;
        });
      }
    });
    _taskBloc = appBloc.taskBloc;
    initializeLocalNotification();
    setState(() {
      promos.add('assets/images/mountains.jpg');
      promos.add('assets/images/shopping.jpeg');
      promos.add('assets/images/payment.jpg');
      promos.add('assets/images/profile.jpg');
      promos.add('assets/images/verification.jpg');
    });

    _taskBloc.getTasksById(widget.userId);
    _taskBloc.getTasks.listen((snapshot) {
      snapshot.documents.forEach((document) => print(document.documentID));
      if (this.mounted) {
        setState(() {
          _tasks = snapshot;
        });
        _handleTaskNotification(snapshot);
      }
    });

    if (this.mounted) {
      _initializedCurrentLocation();
      _getDisplayName();
    }
  }

  void _getDisplayName() {
    _employerBloc.getEmployerName(widget.userId).then((name){
      setState(() {
        _displayName = name;
        if (_displayName == null || _displayName.isEmpty) {
          _displayName = '';
        }
      });
    });

  }

  void _handleTaskNotification(QuerySnapshot snapshot) {
    if (snapshot.documents.isNotEmpty) {
      if (_notification == AppLifecycleState.paused) {
        _showNotification(snapshot.documents.last);
      }

      if (_notification == null || _notification == AppLifecycleState.resumed) {
        switch (snapshot.documents.last.data['status']) {
          case 'accepted':
            print('job accepted');
            _navigateToJobAcceptedPage(snapshot.documents.last.reference,
                Task.fromSnapshot(snapshot.documents.last));
            break;
          case 'rejected':
            _navigateToJobRejectedPage(snapshot.documents.last.reference,
                Task.fromSnapshot(snapshot.documents.last));
            break;
          default:
        }
      }
    }
  }

  void _navigateToJobRejectedPage(DocumentReference reference, Task task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobRejectedPage(
                  reference: reference,
                  task: task,
                )));
  }

  void _navigateToJobAcceptedPage(DocumentReference reference, Task task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobAcceptedPage(
                  reference: reference,
                  task: task,
                )));
  }

  void _initializedCurrentLocation() {
    geoService.getCurrentPosition().then((currentPosition) {
      setState(() {
        _currentLocation = currentPosition;
      });
    });

    Geolocator().getPositionStream().listen((currentPosition) {
      if (currentPosition != null && _currentLocation != null) {
        if (currentPosition.latitude != _currentLocation.latitude ||
            currentPosition.longitude != _currentLocation.longitude) {
          setState(() {
            _currentLocation = currentPosition;
          });
        }
      }
    });
  }

  void onSubmitted(query) {
    setState(() {
      if (query.toString().isNotEmpty) {
        _results = _currentWorkers.where((snapshot) {
          return snapshot.data.toString().toLowerCase().contains(query);
        }).toList();
        _results.isNotEmpty
            ? _currentWorkers = _results
            : _searchNotFound(query.toString());
      }
    });
  }

  Future<void> _searchNotFound(String query) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not Found - ' + query.toUpperCase()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('There\'s no result for the term ' + query),
                Text('Try using other term'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  _results.clear();
                  _currentWorkers = _workers;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    await widget.auth.signOut();
    widget.onSignedOut();
  }

  void initializeLocalNotification() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future _showNotification(DocumentSnapshot snapshot) async {
    Task task = Task.fromSnapshot(snapshot);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, task.title, task.description, platformChannelSpecifics,
        payload: snapshot.documentID);
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text('Ok'),
                onPressed: () async {
                  print('onDidReceiveLocalNotification');
                },
              )
            ],
          ),
    );
  }

  Future onSelectNotification(String payload) async {
    var snapshot =
        _tasks.documents.singleWhere((doc) => doc.documentID == payload);
    if (snapshot != null && snapshot.exists) {
      if (snapshot.data['status'] == 'rejected') {
        _navigateToJobRejectedPage(
            snapshot.reference, Task.fromSnapshot(snapshot));
      }

      if (snapshot.data['status'] == 'accepted') {
        _navigateToJobAcceptedPage(
            snapshot.reference, Task.fromSnapshot(snapshot));
      }
    }
  }
}
