import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 3.5,
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text('Credit Remaining'),
                subtitle: Text('Last updated -'),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            Card(
              elevation: 3.5,
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text('Buy Credit'),
                subtitle: Text('Last updated -'),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            Card(
              elevation: 3.5,
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text('Coupon Code'),
                subtitle: Text('Last updated -'),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
