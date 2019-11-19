import 'package:TolongAppEmployer/models/worker.dart';
import 'package:TolongAppEmployer/widgets/helper/helper_card.dart';
import 'package:TolongAppEmployer/widgets/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum AvailabilityFilter { available, notAvailable, all }
enum RatingFilter { one, two, three, four, five, all }

class CategoryScreen extends StatefulWidget {
  final String title;
  final bool isAnonymous;
  final List<DocumentSnapshot> snapshot;
  final String userId;
  final Position position;

  CategoryScreen(
      {Key key,
      @required this.title,
      this.isAnonymous,
      this.snapshot,
      @required this.userId,
      this.position})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Worker> items;
  List<Worker> currentWorkerList;
  List<num> ratingFilter = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    setState(() {
      currentWorkerList =
          widget.snapshot.map((doc) => Worker.fromSnapshot(doc)).toList();
      items = currentWorkerList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            _displayBanner(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildAvailabilityContainer(context),
                _buildRatingContainer(context),
              ],
            ),
            Expanded(
              child: _displayWorkers(),
            ),
          ],
        ),
      ),
    );
  }

  Image _displayBanner(BuildContext context) {
    return Image.asset(
      'assets/images/mountains.jpeg',
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Container _buildRatingContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
          color: Colors.grey, border: Border(left: BorderSide(width: 1.0))),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PopupMenuButton<RatingFilter>(
              onSelected: (RatingFilter result) {
                setState(() {
                  if (result == RatingFilter.all) {
                    this.currentWorkerList = this.items;
                  }
                  if (result == RatingFilter.one) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.rating == 1)
                        .toList();
                  }
                  if (result == RatingFilter.two) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.rating == 2)
                        .toList();
                  }
                  if (result == RatingFilter.three) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.rating == 3)
                        .toList();
                  }
                  if (result == RatingFilter.four) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.rating == 4)
                        .toList();
                  }
                  if (result == RatingFilter.five) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.rating == 5)
                        .toList();
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Rating',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<RatingFilter>>[
                    const PopupMenuItem<RatingFilter>(
                      value: RatingFilter.one,
                      child: RatingWidget(rating: 1),
                    ),
                    const PopupMenuItem<RatingFilter>(
                      value: RatingFilter.two,
                      child: RatingWidget(rating: 2),
                    ),
                    const PopupMenuItem<RatingFilter>(
                      value: RatingFilter.three,
                      child: RatingWidget(rating: 3),
                    ),
                    const PopupMenuItem<RatingFilter>(
                      value: RatingFilter.four,
                      child: RatingWidget(rating: 4),
                    ),
                    const PopupMenuItem<RatingFilter>(
                      value: RatingFilter.five,
                      child: RatingWidget(rating: 5),
                    ),
                    const PopupMenuItem<RatingFilter>(
                      value: RatingFilter.all,
                      child: Text('All Rating'),
                    ),
                  ],
            )
          ],
        ),
      ),
    );
  }

  Container _buildAvailabilityContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PopupMenuButton<AvailabilityFilter>(
              onSelected: (AvailabilityFilter result) {
                setState(() {
                  if (result == AvailabilityFilter.available) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.availability == true)
                        .toList();
                  }
                  if (result == AvailabilityFilter.notAvailable) {
                    this.currentWorkerList = this
                        .items
                        .where((worker) => worker.availability == false)
                        .toList();
                  }
                  if (result == AvailabilityFilter.all) {
                    this.currentWorkerList = this.items;
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Availability',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<AvailabilityFilter>>[
                    const PopupMenuItem<AvailabilityFilter>(
                      value: AvailabilityFilter.available,
                      child: Text('Available'),
                    ),
                    const PopupMenuItem<AvailabilityFilter>(
                      value: AvailabilityFilter.notAvailable,
                      child: Text('Not Available'),
                    ),
                    const PopupMenuItem<AvailabilityFilter>(
                      value: AvailabilityFilter.all,
                      child: Text('Both'),
                    ),
                  ],
            )
          ],
        ),
      ),
    );
  }

  Widget _displayWorkers() {
    if (currentWorkerList == null || currentWorkerList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(26.0),
        child: Center(child: Text('There is no helper available')),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: this.currentWorkerList.length,
      itemBuilder: (context, index) {
        return new HelperCard(
          hasPermission: widget.isAnonymous ? false : true,
          snapshot: widget.snapshot[index],
          uid: widget.userId,
          location: widget.position,
        );
      },
    );
  }
}
