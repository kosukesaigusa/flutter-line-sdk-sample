import 'package:flutter/material.dart';
import 'package:flutter_line_sdk_sample/components/drawer/drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
        ),
        drawer: AppDrawer(),
        body: const Center(child: Text('サインイン済み')),
      );
}
