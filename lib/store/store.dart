import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_line_sdk_sample/utils/shared_preferences/shared_preferences.dart';

class Store extends ChangeNotifier {
  factory Store() => _instance;
  Store._internal();
  static final Store _instance = Store._internal();

  /// サインイン済みかどうか
  Future<bool> get signedIn async {
    final storedAccessToken = await LineSDK.instance.currentAccessToken;
    if (storedAccessToken == null) {
      return false;
    }
    return storedAccessToken.value.isNotEmpty;
  }

  /// SharedPreferences からアクセストークンの文字列を取得する
  Future<String> get accessToken async {
    return PreferenceKey.accessToken.getString();
  }

  /// アクセストークンを取得する
  Future<StoredAccessToken?> get storedAccessToken async {
    return LineSDK.instance.currentAccessToken;
  }

  /// LINE SDK でログインする
  Future<LoginResult?> signIn() async {
    LoginResult result;
    try {
      result = await LineSDK.instance.login(
        option: LoginOption(false, 'aggressive'),
      );
    } on PlatformException catch (e) {
      var message = 'エラーが発生しました。';
      if (e.code == '3003') {
        message = 'キャンセルしました。';
      }
      throw PlatformException(code: e.code, message: message);
    }
    return result;
  }

  /// LINE SDK でログアウトする
  Future<void> signOut() async {
    try {
      await LineSDK.instance.logout();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
