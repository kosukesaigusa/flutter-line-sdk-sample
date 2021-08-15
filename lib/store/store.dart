import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_line_sdk_sample/models/local_user_profile/local_user_profile.dart';
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
      result = await LineSDK.instance.login();
    } on PlatformException catch (e) {
      print(e);
      throw PlatformException(code: e.code);
      // _showDialog(context, e.toString());
    }
    await setLoginToken(result.accessToken.value);
    await setUserProfiles(result);
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

  /// SharedPreferences にアクセストークンを保存する
  Future<void> setLoginToken(String value) async {
    await PreferenceKey.accessToken.setString(value);
  }

  /// SharedPreferences にユーザープロフィールを保存する
  Future<void> setUserProfiles(LoginResult result) async {
    final userProfile = result.userProfile;
    if (userProfile == null) {
      return;
    }
    await PreferenceKey.userId.setString(userProfile.userId);
    await PreferenceKey.displayName.setString(userProfile.displayName);
    await PreferenceKey.pictureUrl.setString(userProfile.pictureUrl ?? '');
  }

  /// SharedPreferences に保存した UserProfile を取得する
  Future<LocalUserProfile> getLocalUserProfile() async {
    final userId = await PreferenceKey.userId.getString();
    final displayName = await PreferenceKey.displayName.getString();
    final pictureUrl = await PreferenceKey.pictureUrl.getString();
    return LocalUserProfile(
      userId: userId,
      displayName: displayName,
      pictureUrl: pictureUrl,
    );
  }

  /// SharedPreferences に保存している値を削除する
  Future<void> removeSharePreferences() async {
    await PreferenceKey.accessToken.remove();
  }
}
