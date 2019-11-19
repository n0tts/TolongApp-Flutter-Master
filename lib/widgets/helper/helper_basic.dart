import 'package:TolongAppEmployer/models/worker.dart';
import 'package:TolongAppEmployer/utils/list_utils.dart';
import 'package:TolongAppEmployer/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HelperBasicDetail extends StatefulWidget {
  final Worker worker;

  HelperBasicDetail({
    Key key,
    this.worker,
  }) : super(key: key);

  _HelperBasicDetailState createState() => _HelperBasicDetailState();
}

class _HelperBasicDetailState extends State<HelperBasicDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: 80,
                  backgroundImage: widget.worker.profileImage.isNotEmpty
                      ? CachedNetworkImageProvider(widget.worker.profileImage)
                      : AssetImage('assets/images/logos/logo.png')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Center(
            child: new RatingWidget(rating: widget.worker.rating),
          ),
        ),
        Center(
          child: Text(
            ListUtils.parseListToString(widget.worker.jobPosition),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Text(
            widget.worker.firstName + ' ' + widget.worker.lastName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
