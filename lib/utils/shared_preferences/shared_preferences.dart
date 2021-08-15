import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKey {
  accessToken,
  userId,
  displayName,
  pictureUrl,
}

extension PreferenceKeyExtention on PreferenceKey {
  String get keyString {
    switch (this) {
      case PreferenceKey.accessToken:
        return 'accessToken';
      case PreferenceKey.userId:
        return 'userId';
      case PreferenceKey.displayName:
        return 'displayName';
      case PreferenceKey.pictureUrl:
        return 'pictureUrl';
    }
  }

  Future<bool> setString(String value) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setString(keyString, value);
  }

  Future<String> getString({String defaultValue = ''}) async {
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(keyString)) {
      return sp.getString(keyString)!;
    } else {
      return defaultValue;
    }
  }

  Future<void> remove() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(keyString);
  }
}
