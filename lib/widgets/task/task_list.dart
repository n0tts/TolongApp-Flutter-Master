import 'package:TolongAppEmployer/models/task.dart';
import 'package:TolongAppEmployer/widgets/rating.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final Task task;
  TaskList({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title[0].toUpperCase() + task.title.substring(1),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    new RatingWidget(
                      rating: task.rating == null || task.rating.isNaN
                          ? 0
                          : task.rating,
                      alignCenter: false,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.black54,
                        size: 16.0,
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        task.location,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 2.0,
          color: Colors.grey,
        )
      ],
    );
  }
}
