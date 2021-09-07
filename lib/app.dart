import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_line_sdk_sample/models/user_state/user_state.dart';
import 'package:flutter_line_sdk_sample/pages/home/home_page.dart';
import 'package:flutter_line_sdk_sample/pages/sign_in/sign_in_page.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';
import 'package:flutter_line_sdk_sample/theme/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LINE SDK Sample',
      theme: lightTheme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: InitialWidget(),
    );
  }
}

/// アプリ起動時にはじめに生成されるウィジェット
class InitialWidget extends StatelessWidget {
  final store = Store();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<UserState>(
          stream: initStream(),
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case null:
              case UserState.waiting:
                return Center(
                  child: SpinKitCircle(
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              case UserState.signedOut:
                return SignInPage();
              case UserState.signedIn:
                return HomePage();
            }
          },
        ),
      );

  /// ユーザーのログイン状態を確認して Stream で返す
  Stream<UserState> initStream() async* {
    yield UserState.waiting;
    final signedIn = await store.signedIn;
    if (signedIn) {
      yield UserState.signedIn;
    } else {
      yield UserState.signedOut;
    }
  }
}
