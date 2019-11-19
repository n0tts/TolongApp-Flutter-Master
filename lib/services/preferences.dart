import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences();
  Future<String> getEmployerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('employerId');
  }

  Future<void> setEmployerId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('employerId', uid);
  }
}

AppPreferences preferences = new AppPreferences();
