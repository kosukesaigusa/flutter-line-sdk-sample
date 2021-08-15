/// LINE ログイン時にもらえるユーザープロフィール
class LocalUserProfile {
  LocalUserProfile({
    required this.userId,
    required this.displayName,
    required this.pictureUrl,
  });

  final String userId;
  final String displayName;
  final String? pictureUrl;
}
