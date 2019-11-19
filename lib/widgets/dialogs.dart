import 'package:flutter/material.dart';

class Dialogs {
  job(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Title'),
                  Text('Description'),
                  FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[Text('OK')],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
