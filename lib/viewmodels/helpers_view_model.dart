import 'dart:async';
import 'dart:convert';

import 'package:TolongAppEmployer/models/helper.dart';
import 'package:TolongAppEmployer/services/helpers.dart';
import 'package:flutter/services.dart';

class HelpersViewModel {
  static List<Helper> helpers = new List<Helper>();
  HelperService db = new HelperService();
  
  static Future<String> getHelpers() async {
    return await rootBundle.loadString('assets/helpers.json');
  }

  static Future load() async{
    List jsonParsed = json.decode(await getHelpers());
    helpers = jsonParsed.map((i) => new Helper.fromJson(i)).toList();
  }
}