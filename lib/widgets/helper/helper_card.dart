import 'package:TolongAppEmployer/models/worker.dart';
import 'package:TolongAppEmployer/screens/helper_details.dart';
import 'package:TolongAppEmployer/services/geolocator.dart';
import 'package:TolongAppEmployer/widgets/helper/helper_availability.dart';
import 'package:TolongAppEmployer/widgets/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HelperCard extends StatefulWidget {
  final bool hasPermission;
  final DocumentSnapshot snapshot;
  final String uid;
  final Position location;

  HelperCard(
      {Key key, this.hasPermission, this.snapshot, this.uid, this.location})
      : super(key: key);

  _HelperCardState createState() => _HelperCardState();
}

class _HelperCardState extends State<HelperCard> {
  Color favColor = Colors.grey;
  GeolocatorService geoService = new GeolocatorService();
  Worker _worker;
  ImageProvider _profile;
  String _distance;

  @override
  void initState() {
    super.initState();
    setState(() {
      _distance = '0 KM';
      _worker = Worker.fromSnapshot(widget.snapshot);
      _profile = AssetImage('assets/images/logos/logo.png');
      if (_worker.profileImage != null && _worker.profileImage.isNotEmpty) {
        _profile = CachedNetworkImageProvider(_worker.profileImage);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Access Denied"),
          content: new Text(
              "Only registered user is allowed to view helper details."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentDistance();
    return InkWell(
        onTap: () {
          if (!widget.hasPermission) {
            _showVerifyEmailDialog();
          }
        },
        child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
            child: new Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0)),
                              image: DecorationImage(
                                  image: _profile, fit: BoxFit.cover)),
                        )),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_worker.category.toUpperCase()),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    _worker.firstName.replaceFirst(
                                            _worker.firstName[0],
                                            _worker.firstName[0].toUpperCase(),
                                            0) +
                                        ' ' +
                                        _worker.lastName.replaceFirst(
                                            _worker.lastName[0],
                                            _worker.lastName[0].toUpperCase(),
                                            0),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  RatingWidget(
                                    rating: _worker.rating,
                                    alignCenter: false,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Location'),
                                          Text(_distance,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: <Widget>[
                                        new HelperAvailability(
                                            isAvailable: widget
                                                .snapshot.data['availability']),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.attach_money,
                                              size: 16.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Flexible(
                                              child: Text('8.00/Hr'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(height: 2.0, color: Colors.grey),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 10.0, 16.0, 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      widget.hasPermission
                                          ? _navigateToDetailScreen(true)
                                          : _showVerifyEmailDialog();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Icon(FontAwesomeIcons.calendar,
                                          size: 20.0, color: Colors.blue),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.hasPermission
                                          ? _navigateToDetailScreen(false)
                                          : _showVerifyEmailDialog();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Icon(FontAwesomeIcons.userTag,
                                          size: 20.0, color: Colors.green),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        favColor = favColor == Colors.grey
                                            ? Colors.red
                                            : Colors.grey;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Icon(
                                        FontAwesomeIcons.solidHeart,
                                        size: 20.0,
                                        color: favColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  void _currentDistance() async {
    GeoPoint workerLocation = widget.snapshot.data['currentLocation'];
    double dist = await geoService.getDistance(
        widget.location,
        new Position(
            latitude: workerLocation.latitude,
            longitude: workerLocation.longitude));
    if(this.mounted){
      setState(() {
        _distance = (dist / 1000).toStringAsFixed(2) + ' KM';
      });
    }
  }

  void _navigateToDetailScreen(bool showSchedule) {
    print('helper reference ' + widget.snapshot.documentID);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HelperDetailScreen(
                worker: _worker,
                showSchedule: showSchedule,
                hid: widget.snapshot.documentID,
                uid: widget.uid,
              )),
    );
  }
}
