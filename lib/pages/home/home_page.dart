import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_line_sdk_sample/components/cached_network_image/circle_user_icon.dart';
import 'package:flutter_line_sdk_sample/components/drawer/drawer.dart';
import 'package:flutter_line_sdk_sample/models/local_user_profile/local_user_profile.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';
import 'package:gap/gap.dart';

class HomePage extends StatelessWidget {
  final store = Store();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: store.getLocalUserProfile(),
          // TODO: 下記で書き直したほうがスマートなので後で編集する
          // future: LineSDK.instance.getProfile(),
          builder: (
            context,
            // ignore: avoid_types_on_closure_parameters
            AsyncSnapshot<LocalUserProfile> snapshot,
            // AsyncSnapshot<UserProfile> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleUserIcon(radius: 160, imageURL: data.pictureUrl),
                    const Gap(24),
                    Text(
                      data.displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text('${data.userId.substring(0, 8)}...'),
                    TextButton(
                      onPressed: () async {
                        final currentToken = await store.storedAccessToken;
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
          },
        ),
      );
}
