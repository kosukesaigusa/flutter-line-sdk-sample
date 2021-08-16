---
theme: default
background: https://source.unsplash.com/collection/94734566/1920x1080
class: 'text-center'
highlighter: shiki
info: |
  ## Slidev Starter Template
  Presentation slides for developers.

  Learn more at [Sli.dev](https://sli.dev)
fonts:
  sans: 'Roboto'
  serif: 'Roboto'
  mono: 'Fira Code'
---

# Flutter アプリで<br>LINE ログインを実装する

2021-09-08 (水) Flutter 大学勉強会 LT by Kosuke Saigusa

---

## 自己紹介

- 30 秒ほどで軽く自己紹介

---

## LINE ログインと Flutter LINE SDK

以下のようなリンクを参考に、LINE ログインと Flutter LINE SDK について簡単に触れる

- [LINE Developers](https://developers.line.biz/ja/services/line-login/)
- [flutter_line_sdk (GitHub)](https://github.com/line/flutter_line_sdk/)
- [flutter_line_sdk (pub.dev)](https://pub.dev/packages/flutter_line_sdk)

---

## LINE ログインを実装するメリット

LINE DC の方からの内容と被ったりして問題にならなければ、考えられる Flutter アプリに LINE ログインを実装するメリットを軽く述べる。

- 日本にいるスマホユーザーならほぼ全員が LINE アカウントを持っており、面倒なアカウント登録やプロフィール入力の手間が省ける。
- ログイン時に LINE の公式アカウントと友だちになるよう促せる。それによって、たとえばサービスの利用状況に応じた最適な顧客とのコミュニケーションなどが可能になる。
- [flutter_line_sdk (pub.dev)](https://pub.dev/packages/flutter_line_sdk) のおかげで実装もすごく簡単。

---

## ハンズオンの内容

当日のハンズオンの流れを説明する。

1. Flutter アプリに [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) を導入する。
2. [LINE Developers](https://developers.line.biz/console/) でアカウントを作成し、LINE ログイン用のチャネルと、公式アカウントのチャネル（今回は Messaging API にした）を作成し、LINE ログイン用のチャネルに Messaging API を連携させる。
3. Flutter アプリで LINE ログインの API を実行する。`LoginOption` の `botPrompt` を指定して、ログイン時に公式アカウントを友だち追加するよう促す。ログインが成功してアクセストークンがもらえること、LINE の表示名やプロフィール画像ももらえることを確認する
4. LINE アカウントのプロフィール情報を Flutter の Widget として表示する

---

## 手順 1. Flutter アプリに [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) を導入する

基本的には [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) の README に沿って進めれば OK。

pubspec.yaml

```yaml
dependencies:
  flutter_line_sdk: ^2.0.0
```

main.dart

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // チャンネル ID は後で LINE Developers の LINE ログインのチャネルから取得する
  LineSDK.instance.setup('<チャンネル ID>').then((_) {
    print('LineSDK Prepared');
  });
  runApp(App());
}
```

---

ios/Runner/Info.plist

```
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- Specify URL scheme to use when returning from LINE to your app. -->
      <string>line3rdp.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <!-- Specify URL scheme to use when launching LINE from your app. -->
  <string>lineauth2</string>
</array>
```

---

ios/Podfile

```
target 'Runner' do
   use_frameworks!
   platform :ios, '10.0'
```

Flutter アプリのソースコードとしての導入準備は以上で終わり。

---

## 手順 2. [LINE Developers](https://developers.line.biz/console/) での準備

[LINE Developers](https://developers.line.biz/console/) のコンソール上で必要になる準備を、コンソール画面のスクリーンショットを交えながら簡単に説明する。

スクリーンショットなどは準備中。説明する内容は下記の通り。

- [LINE Developers](https://developers.line.biz/console/) でアカウントを作成する
- LINE ログインのチャネルを作成する
- LINE ログインチャネルの LINE ログイン設定から、iOS, Android アプリの bundle ID やパッケージ名などを設定する
- LINE ログインチャネルと同じプロバイダーを指定して、Messaging API のチャネル（公式アカウント）を作成する
- LINE ログインチャネルから、Messaging API のチャネルを「リンクされたボット」に指定する

---

## 手順 3. Flutter アプリで LINE ログインの API を実行する

LINE ログインの API を実行する記述は下記のようにするだけ。

```dart
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

Future<void> signIn() async {
  try {
    result = await LineSDK.instance.login();
  } on PlatformException catch (e) {
    throw PlatformException(code: e.code);
  }
}
```

Simulator の画面か、予め準備した画面収録を共有しながら

- LINE アプリがインストールされていない Simulator では LINE ログインのための Web 画面が開かれて、LINE アカウントのメールアドレスとパスワードを入力して認証ができること
- LINE アプリをインストール済みの実機では、LINE アプリが起動して認証が済むこと

をその場で見てもらう。

App Store Connect の TestFlight では、内部テスター配信できるようにしているので、Flutter 大学内の何人かの希望者に予めテスター登録してもらっておいて、その場でやってみるのも良いかもしれない。

---

`login` メソッドの返す `LoginResult` クラスを少し見てみる。

```dart
result = await LineSDK.instance.login();
```

- `result.accessToken` の getter `AccessToken` 型のアクセストークンインスタンスがもらえること
- `accessToken.value` でアクセストークンの文字列を確認できること
- `accessToken.expiresIn` にはアクセストークンの有効期限（2592000秒 = 30日）が入っていること

も確認する。

続いて、LINE ログイン時に LINE ログインチャネルと連携している LINE 公式アカウントを友だち追加するよう促すオプションを追加する方法を述べる。`login` メソッドに下記のオプションを記述するだけ。

参考：[LINEログインしたときにLINE公式アカウントを友だち追加する（ボットリンク）](https://developers.line.biz/ja/docs/line-login/link-a-bot/)

```dart
result = await LineSDK.instance.login(
  // デモで見せるような、LINEログインの同意画面の後に、LINE 公式アカウントを友だち追加するかどうか確認する画面を表示する場合
  option: LoginOption(false, 'aggressive'),
  // LINEログインの同意画面の下部に、LINE 公式アカウントを友だち追加するオプションを表示する場合
  // option: LoginOption(false, 'normal'),

  // 補足：LoginOption の第一引数は真偽値型の `onlyWebLogin`
);
```

---

また、`login` メソッドの引数 `scopes` には、デフォルトで `[profile]` が指定されているので、特に何も書かなければ下記と同等で、ユーザーのプロフィール情報（`UserProfile` 型）がもらえる。

`result.userProfile` には、下記のような情報が入っている。

- `String` displayName（LINE の登録名）
- `String` userID（ユーザー ID）
- `String?` statusMessage（LINE のひとこと）
- `String?` pictureUrl（LINE のプロフィール画像）

```dart
result = await LineSDK.instance.login(scopes: const ['profile']);
print(result.userProfile.displayName);
print(result.userProfile.userId);
print(result.statusMessage);
print(result.pictureUrl);
```

---

## 手順 4：LINE アカウントのプロフィール情報を Flutter の Widget として表示する

LINE アカウントのプロフィール情報は、`Text` ウィジェットや `Image` ウィジェットなどで表示すれば OK！

Flutter 大学で勉強している皆さんには簡単ですね！（`LineSDK.instance.getProfile()` が `Future<UserProfile>` を返すので、`FutureBuilder` を使いました）

```dart
FutureBuilder(
  future: LineSDK.instance.getProfile(),
  builder: (context, AsyncSnapshot<UserProfile> snapshot){
    if (!snapshot.hasData) {
      return const SizedBox();
    }
    final userProfile = snapshot.data!;
    return Column(
      children: [
        Text('表示名：${userProfile.displayName}'),
        userProfile.pictureUrl == null
          ? Icon(Icons.person)
          : Image.network(userProfile.pictureUrl!),
      ],
    );
  },
)
```

---

## まとめ

最後に実装のポイントや、やってみた感想や「こんなふうに応用すると面白そうだ」というのを最後に述べて終わり。
