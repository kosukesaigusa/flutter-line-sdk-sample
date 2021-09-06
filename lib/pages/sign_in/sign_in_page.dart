import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_line_sdk_sample/pages/home/home_page.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';
import 'package:flutter_line_sdk_sample/utils/snackbar/show_snack_bar.dart';

class SignInPage extends StatelessWidget {
  final store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サインイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await store.signIn();
                  if (result == null) {
                    showFloatingSnackBar(context, 'ログインに失敗しました。');
                    return;
                  }
                  await Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                } on PlatformException catch (e) {
                  if (e.message != null) {
                    showFloatingSnackBar(context, e.message!);
                    return;
                  }
                  showFloatingSnackBar(context, 'キャンセルしました。');
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'LINE で Login する',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
