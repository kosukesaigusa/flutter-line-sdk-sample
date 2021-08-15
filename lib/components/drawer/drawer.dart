import 'package:flutter/material.dart';
import 'package:flutter_line_sdk_sample/pages/sign_in/sign_in_page.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';
import 'package:flutter_line_sdk_sample/utils/snackbar/show_snack_bar.dart';

class AppDrawer extends StatelessWidget {
  final store = Store();
  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(context),
            signOutItem(context),
          ],
        ),
      );

  DrawerHeader drawerHeader(BuildContext context) => DrawerHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('ドロワーヘッダー'),
          ],
        ),
      );

  ListTile signOutItem(BuildContext context) => ListTile(
        leading: const Icon(Icons.logout_outlined),
        title: const Text('サインアウト'),
        onTap: () async {
          try {
            await store.signOut();
          } catch (e) {
            showFloatingSnackBar(context, 'エラーが発生しました。');
          }
          await Navigator.of(context).pushAndRemoveUntil<void>(
            MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false,
          );
        },
      );
}
