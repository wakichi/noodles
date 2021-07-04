// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_design/welcome_screen.dart';

import 'news_tab.dart';
import 'profile_tab.dart';
import 'settings_tab.dart';
import 'songs_tab.dart';
import 'widgets.dart';

void main() => runApp(MyAdaptingApp());

class MyAdaptingApp extends StatelessWidget {
  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    return MaterialApp(
      title: 'benesseもくもく会',
      theme: ThemeData(
        // Use the green theme for Material widgets.
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return CupertinoTheme(
          //クパチーノウィジェットをマテリアルに自動適応させる代わりに
          //テーマ（緑色）、このアプリは別のテーマを使用します
          //クパチーノの場合（デフォルトでは青色）。
          data: const CupertinoThemeData(),
          child: Material(child: child),
        );
      },
      home: PlatformAdaptingHomePage(),
    );
  }
}

//プラットフォームに応じて異なるタイプのスキャフォールドを表示します。
//
//このファイルは、最も動作するため、共有不可能なコードが最も多く含まれています
//プラットフォーム間で異なります。
//
//これらの違いも主観的であり、複数の「正しい」答えがあります
//アプリとコンテンツによって異なります。
class PlatformAdaptingHomePage extends StatefulWidget {
  @override
  _PlatformAdaptingHomePageState createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
  //このアプリは、多数の曲を所有しているため、[曲]タブのグローバルキーを保持します
  //データ。プラットフォームを変更すると、それらのタブが別のタブに再ペアレント化されるため
  //スキャフォールド、グローバルキーを保持すると、このアプリはそのタブのデータを次のように保持できます
  //プラットフォームが切り替わります。
  //
  //これは、実行中にプラットフォームを切り替えないアプリには必要ありません。
  final universityTabKey = GlobalKey();

  // Materialでは、このアプリはハンバーガーメニューパラダイムとフラットリストを使用します
  // 4つの可能なタブすべて。この引き出しは、曲タブに挿入されます。
  //実際に引き出しの周りに足場を構築します。
  Widget _buildAndroidHomePage(BuildContext context) {
    return WelcomeScreen();
  }

 // iOSでは、アプリは下部タブパラダイムを使用します。ここでは、各タブビューが内部にあります
  //タブスキャフォールド内のタブ。タブスキャフォールドはタブバーも配置します
  //一番下の行に。
  //
  //注意すべき重要なことは、マテリアルドロワーは
  //多数のアイテム、タブバーはできません。調整の1つの方法を説明するため
  //このために、アプリは4番目のタブ（設定ページ）を
  // 3番目のタブ。これはiOSで一般的なパターンです。
  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: SongTab.title,
            icon: SongTab.iosIcon,
          ),
          BottomNavigationBarItem(
            label: NewsTab.title,
            icon: NewsTab.iosIcon,
          ),
          BottomNavigationBarItem(
            label: ProfileTab.title,
            icon: ProfileTab.iosIcon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: SongTab.title,
              builder: (context) => SongTab(key: universityTabKey),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: NewsTab.title,
              builder: (context) => NewsTab(),
            );
          case 2:
            return CupertinoTabView(
              defaultTitle: ProfileTab.title,
              builder: (context) => ProfileTab(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildIosHomePage,
    );
  }
}

class _AndroidDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Icon(
                Icons.account_circle,
                color: Colors.blue.shade800,
                size: 96,
              ),
            ),
          ),
          ListTile(
            leading: SongTab.androidIcon,
            title: const Text(SongTab.title),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: NewsTab.androidIcon,
            title: const Text(NewsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context, MaterialPageRoute(builder: (context) => NewsTab()));
            },
          ),
          ListTile(
            leading: ProfileTab.androidIcon,
            title: const Text(ProfileTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => ProfileTab()));
            },
          ),
          // Long drawer contents are often segmented.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          ListTile(
            leading: SettingsTab.androidIcon,
            title: const Text(SettingsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => SettingsTab()));
            },
          ),
        ],
      ),
    );
  }
}
