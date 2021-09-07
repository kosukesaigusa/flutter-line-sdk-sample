import 'package:flutter/material.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:provider/provider.dart';

import 'package:flutter_line_sdk_sample/app.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = Store();
  LineSDK.instance.setup('1656319899').then((_) {
    print('LineSDK Prepared');
  });
  runApp(
    ChangeNotifierProvider<Store>.value(
      value: store,
      builder: (context, child) => App(),
    ),
  );
}
