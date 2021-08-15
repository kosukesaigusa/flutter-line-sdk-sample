import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
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
                  final result = await store.signLogin();
                  if (result == null) {
                    showFloatingSnackBar(context, 'ログインに失敗しました。');
                    return;
                  }
                  await Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                  // ignore: avoid_catches_without_on_clauses
                } catch (e) {
                  // TODO: 後で書き直す
                  showFloatingSnackBar(context, 'エラーが発生しました。');
                }
              },
              child: const Text('LINE で Login する'),
            ),
            TextButton(
              onPressed: () async {
                final currentToken = await LineSDK.instance.currentAccessToken;
                if (currentToken == null) {
                  print('アクセストークンがありません');
                  return;
                }
                print(currentToken.data);
                print(currentToken.expiresIn);
                print(currentToken.value);
              },
              child: const Text('確認'),
            ),
          ],
        ),
      ),
    );
  }
}
