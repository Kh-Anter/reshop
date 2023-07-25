import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootProvider with ChangeNotifier {
  Future<void> localWriteAboutSplash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstUse', false);
    notifyListeners();
  }
}
