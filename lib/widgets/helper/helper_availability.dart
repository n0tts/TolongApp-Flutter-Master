import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelperAvailability extends StatefulWidget {
  final bool isAvailable;

  HelperAvailability({Key key, this.isAvailable}) : super(key: key);

  _HelperAvailabilityState createState() => _HelperAvailabilityState();
}

class _HelperAvailabilityState extends State<HelperAvailability> {
  String _availability;
  Color _color;

  @override
  Widget build(BuildContext context) {
    _checkAvailability();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          FontAwesomeIcons.solidCircle,
          size: 16,
          color: _color,
        ),
        SizedBox(
          width: 5.0,
        ),
        Flexible(
          child: Column(
            children: <Widget>[Text(_availability)],
          ),
        )
      ],
    );
  }

  void _checkAvailability() {
    if (widget.isAvailable) {
      setState(() {
        _availability = 'Available Today';
        _color = Colors.green;
      });
    } else {
      setState(() {
        _availability = 'Not Available';
        _color = Colors.red;
      });
    }
  }
}
