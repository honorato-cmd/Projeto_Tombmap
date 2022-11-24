import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'views/ios/ios.app.dart';
import 'views/android/android.app.dart';

void main() {
  runApp(Platform.isIOS ? IosApp() : AndroidApp());
}
