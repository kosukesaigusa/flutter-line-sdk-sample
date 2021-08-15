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
    final token = await accessToken;
    return token.isNotEmpty;
  }

  /// SharedPreferences からアクセストークンを取得する
  Future<String> get accessToken async {
    return PreferenceKey.accessToken.getString();
  }

  /// LINE SDK でログインする
  Future<LoginResult?> signLogin() async {
    LoginResult result;
    try {
      result = await LineSDK.instance.login();
      // user id -> result.userProfile?.userId
      // user name -> result.userProfile?.displayName
      // user avatar -> result.userProfile?.pictureUrl
    } on PlatformException catch (e) {
      print(e);
      throw PlatformException(code: e.code);
      // _showDialog(context, e.toString());
    }
    await setLoginToken(result.accessToken.value);
    return result;
  }

  /// LINE SDK でログアウトする
  Future<void> signOut() async {
    try {
      await LineSDK.instance.logout();
    } on PlatformException catch (e) {
      print(e.message);
    }
    await removeSharePreferences();
  }

  /// アクセストークンを SharedPreferences に保存する
  Future<void> setLoginToken(String value) async {
    await PreferenceKey.accessToken.setString(value);
  }

  /// SharedPreferences に保存している値を削除する
  Future<void> removeSharePreferences() async {
    await PreferenceKey.accessToken.remove();
  }
}
