// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'song_detail_tab.dart';
import 'utils.dart';
import 'widgets.dart';

class SongTab extends StatefulWidget {
  static const title = 'もくもく会';
  static const androidIcon = Icon(Icons.cast_for_education);
  static const iosIcon = Icon(CupertinoIcons.music_note);

  const SongTab({Key? key, this.androidDrawer}) : super(key: key);

  final Widget? androidDrawer;

  @override
  _SongTabState createState() => _SongTabState();
}

class _SongTabState extends State<SongTab> {
  static const _itemsLength = 10;

  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  late List<MaterialColor> colors;
  late List<String> songNames;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  void _setData() {
    colors = getRandomColors(10);
    songNames = ['北海道大学','中央大学','東京工業大学','一橋大学','東北学院大学','日本大学','法政大学','東京大学','京都大学','名古屋大学'];
  }

  Future<void> _refreshData() {
    return Future.delayed(
      // This is just an arbitrary delay that simulates some network activity.
      const Duration(seconds: 2),
      () => setState(() => _setData()),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= _itemsLength) return Container();

    // Show a slightly different color palette. Show poppy-ier colors on iOS
    // due to lighter contrasting bars and tone it down on Android.
    final color = defaultTargetPlatform == TargetPlatform.iOS
        ? colors[index]
        : colors[index].shade400;

    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: HeroAnimatingSongCard(
          song: songNames[index],
          color: color,
          heroAnimation: const AlwaysStoppedAnimation(0),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => SongDetailTab(
                id: index,
                song: songNames[index],
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePlatform() {
    TargetPlatform _getOppositePlatform() {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return TargetPlatform.android;
      } else {
        return TargetPlatform.iOS;
      }
    }

    debugDefaultTargetPlatformOverride = _getOppositePlatform();
    // This rebuilds the application. This should obviously never be
    // done in a real app but it's done here since this app
    // unrealistically toggles the current platform for demonstration
    // purposes.
    WidgetsBinding.instance!.reassembleApplication();
  }

  // ===========================================================================
  // Non-shared code below because:
  // - Android and iOS have different scaffolds
  // - There are differenc items in the app bar / nav bar
  // - Android has a hamburger drawer, iOS has bottom tabs
  // - The iOS nav bar is scrollable, Android is not
  // - Pull-to-refresh works differently, and Android has a button to trigger it too
  //
  // And these are all design time choices that doesn't have a single 'right'
  // answer.
  // ===========================================================================
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SongTab.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async =>
                await _androidRefreshKey.currentState!.show(),
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _togglePlatform,
          ),
        ],
      ),
      drawer: widget.androidDrawer,
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: _itemsLength,
          itemBuilder: _listBuilder,
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.shuffle),
            onPressed: _togglePlatform,
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: _refreshData,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _listBuilder,
                childCount: _itemsLength,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
