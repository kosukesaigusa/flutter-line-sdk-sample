import 'package:flutter/material.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:gap/gap.dart';

import 'package:flutter_line_sdk_sample/components/cached_network_image/circle_user_icon.dart';
import 'package:flutter_line_sdk_sample/components/drawer/drawer.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';

class HomePage extends StatelessWidget {
  final store = Store();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder<UserProfile>(
          future: LineSDK.instance.getProfile(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            final userProfile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleUserIcon(radius: 160, imageURL: userProfile.pictureUrl),
                    const Gap(24),
                    Text(
                      userProfile.displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text('${userProfile.userId.substring(0, 8)}...'),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
