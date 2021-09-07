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

- Flutter エンジニア
- Flutter 大学のメンバー、毎週水曜日の共同勉強会の開催にも関わる
- 仕事でよく使う技術は、Flutter, Dart, Django, Python, TypeScript, Nuxt.js など
- 個人開発や本業以外のプロジェクトでは、Flutter と Firebase を使うのが好き
- 認証周りの知識にはまだまだ疎く、LINE API の使用経験などもない

---

## LINE ログインと Flutter LINE SDK

pub.dev に公開されているパッケージの README と LINE Developers のドキュメントに沿って進めると、簡単に実装できます！

- [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk)
- [LINE Developers](https://developers.line.biz/ja/docs/line-login/overview/)

<img src="/pub_dev_flutter_line_sdk.png" class="h-72 rounded-xl" />

---

## LINE ログインを実装するメリット

- 日本にいるスマホユーザーならほぼ全員が LINE アカウントを持っており、面倒なアカウント登録やプロフィール入力の手間が省ける。
- 開発者はログイン時に LINE の公式アカウントと友だちになるよう促せる。それによって、たとえばサービスの利用状況に応じた最適な顧客とのコミュニケーションなどが可能になる。
- [flutter_line_sdk (pub.dev)](https://pub.dev/packages/flutter_line_sdk) のおかげで実装もすごく簡単。

---

## ハンズオンの内容

1. Flutter アプリに [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) を導入する。
2. [LINE Developers](https://developers.line.biz/console/) で作成したアカウントを用いて、LINE ログイン用のチャネルと、公式アカウントのチャネル（今回は Messaging API）を作成し、LINE ログイン用のチャネルに Messaging API を連携させる。
3. Flutter アプリで LINE ログインの API を実行する。`LoginOption` の `botPrompt` を指定して、ログイン時に公式アカウントを友だち追加するよう促す。ログインが成功してアクセストークンがもらえること、LINE の表示名やプロフィール画像ももらえることを確認する
4. LINE アカウントのプロフィール情報を Flutter の Widget として表示する

---

## 手順 1. Flutter アプリに [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) を導入する

基本的には [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) の README に沿って進めれば OK。

`pubspec.yaml` に flutter_line_sdk を記述する。

```yaml
dependencies:
  flutter_line_sdk: ^2.0.0
```

`main.dart` の runApp に下記の記述を加える。

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // チャネル ID は後で LINE Developers の LINE ログインのチャネルから取得する
  LineSDK.instance.setup('<チャネル ID>').then((_) {
    print('LineSDK Prepared');
  });
  runApp(App());
}
```

---

`ios/Runner/Info.plist` に [flutter_line_sdk](https://pub.dev/packages/flutter_line_sdk) の指示通りの下記の内容を加える。

```txt
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

`ios/Podfile` にも書き加える。iOS バージョン 10.0 以上がサポートされている。

```txt
target 'Runner' do
   use_frameworks!
   platform :ios, '10.0'
```

ソースコードに Android 関連の特別な設定の記述はない。

Flutter アプリのソースコードとしての導入準備は以上で終わり！

---

## 手順 2. [LINE Developers](https://developers.line.biz/console/) での準備

Flutter アプリ内のソースコードの編集の他に、下記のような [LINE Developers](https://developers.line.biz/console/) のコンソール画面での設定をいくつか行います。

- [LINE Developers](https://developers.line.biz/console/) でアカウントを作成する
- LINE ログインのチャネルを作成する
- LINE ログインチャネルの LINE ログイン設定から、iOS, Android アプリの bundle ID やパッケージ名などを設定する
- LINE ログインチャネルと同じプロバイダーを指定して、Messaging API のチャネル（公式アカウント）を作成する
- LINE ログインチャネルから、Messaging API のチャネルを「リンクされたボット」に指定する

---

[LINE Developers](https://developers.line.biz/console/) でアカウントを作成する。

LINE を普段使っているスマートフォンが手元にあれば、QR コードで簡単に入れます。

<img src="/LINE_Business_ID.png" class="h-80 rounded-xl" />

---

プロバイダーを作成する。

<img src="/LINE_Developers_top.png" class="h-100 rounded-xl" />

---

プロバイダーを作成する。

<img src="/LINE_Developers_create_provider.png" class="h-100 rounded-xl" />

---

新規チャネル（LINE ログイン）を作成する。

<img src="/LINE_Developers_create_channel_1.png" class="h-100 rounded-xl" />

---

新規チャネル（LINE ログイン）を作成する。

<img src="/LINE_Developers_create_channel_2.png" class="h-100 rounded-xl" />

---

LINE ログインチャネル (Messaging API) を作成

<img src="/LINE_Developers_create_channel_3.png" class="h-100 rounded-xl" />

---

新規チャネルで次の設定を行う。

- 「チャネル基本設定 > リンクされたボット」に先程作った Messaging API のチャネル（ボット）を指定して連携する
- 「LINE ログインアプリ」から、iOS, Android の bundle ID やパッケージ名を設定する。

<img src="/LINE_Developers_link_bot.png" class="h-36 rounded-xl" />

---

## 手順 3. Flutter アプリで LINE ログインの API を実行する

LINE ログインのチャネル ID をして、

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LineSDK.instance.setup('<チャネル ID>').then((_) {
    print('LineSDK Prepared');
  });
  runApp(App());
}
```

LINE ログインの API を実行する記述は下記のようにするだけ！

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

---

`login` メソッドの返す `LoginResult` クラスをデバッグしながら見てみる。

```dart
result = await LineSDK.instance.login();
```

- `result.accessToken` の getter で `AccessToken` 型のアクセストークンインスタンスがもらえていることが確認できる
- `accessToken.value` でアクセストークンの文字列を確認できる
- `accessToken.expiresIn` にはアクセストークンの有効期限（2592000秒 = 30日）が入っている
- `accessToken.userProfile` に、LINE に登録しているプロフィール情報が入っている

この後の発表では Fujie さんが

- LINE ログインの裏側で何が起こっているのか
- OpenID Connect について

などのお話をして下さいます！🙌

---

LINE ログイン時に LINE ログインチャネルと連携している LINE 公式アカウントを友だち追加するよう促すには...

`login` メソッドに下記のオプションを記述するだけ！

参考：[LINEログインしたときにLINE公式アカウントを友だち追加する（ボットリンク）](https://developers.line.biz/ja/docs/line-login/link-a-bot/)

```dart
result = await LineSDK.instance.login(
  // LINEログインの同意画面の後に、LINE 公式アカウントを友だち追加するかどうか確認する画面を表示する場合
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

今回はシングルトンの `Store` クラスに LINE SDK のログイン・ログアウト、サインイン済みチェックを取得するためのメソッドや getter を定義することにしました。

下記のように、ルートウィジェットの上の `ChangeNotifierProvider.value()` で `Store` クラスのインスタンスを指定すると、アプリケーションのどこからでも同じインスタンスを参照することができます。

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = Store();
  LineSDK.instance.setup('1656319899').then((_) {
    print('LineSDK Prepared');
  });
  runApp(
    ChangeNotifierProvider<Store>.value(
      value: store,
      builder: (context, child) => App(),
    ),
  );
}
```

---

LINE アカウントのプロフィール情報は、`Text` ウィジェットや `Image` ウィジェットなどで表示すれば OK！

Flutter 大学で勉強している皆さんには簡単ですね！（`LineSDK.instance.getProfile()` が `Future<UserProfile>` を返すので、`FutureBuilder` を使いました）

```dart
FutureBuilder<UserProfile>(
  future: LineSDK.instance.getProfile(),
  builder: (context, snapshot){
    if (!snapshot.hasData) {
      return const SizedBox();
    }
    final userProfile = snapshot.data!;
    return Column(
      children: [
        Text('表示名：${userProfile.displayName}'),
        userProfile.pictureUrl == null
          ? const Icon(Icons.person)
          : Image.network(userProfile.pictureUrl!),
      ],
    );
  },
)
```

---

## まとめ

- LINE SDK for Flutter の活用はドキュメント通りに進めれば非常に簡単に実装可能！
- LINE Messaging API を活用すれば、よりユーザーのセグメントに合わせた、またはユーザーとの相互のコミュニケーションを伴うアプリの開発・運用が可能になる
- Flutter 大学の方の中には、Firebase Auth を好んで使っている方も多いと思いますが、カスタムトークン認証を実装すれば、LINE ログインと Firebase Auth とを連携させることも可能（後日実装して記事を書きたいです）
- エンジニアが知っておくべき認証周りの知識はこの後の Fujie さんの発表で勉強しましょう！🧑‍💻 💪
