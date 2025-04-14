import 'package:flutter/material.dart';
import 'package:hoteque_app/app_root.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(AppRoot(sharedPrefs: sharedPrefs));
}