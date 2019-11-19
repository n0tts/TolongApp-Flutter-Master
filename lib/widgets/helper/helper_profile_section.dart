import 'package:flutter/material.dart';

class HelperProfileSection extends StatelessWidget {
  final String title;
  final String description;
  HelperProfileSection({Key key, this.title, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                description,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
