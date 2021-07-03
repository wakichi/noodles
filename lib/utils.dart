// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:english_words/english_words.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';

// This file has a number of platform-agnostic non-Widget utility functions.

const _myListOfRandomColors = [
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.lime,
  Colors.pink,
  Colors.orange,
];

final _random = Random();

// Avoid customizing the word generator, which can be slow.
// https://github.com/filiph/english_words/issues/9
final wordPairIterator = generateWordPairs();

String generateRandomHeadline() {
  final artist = capitalizePair(wordPairIterator.first);

  switch (_random.nextInt(10)) {
    case 0:
      //return '$artist says ${nouns[_random.nextInt(nouns.length)]}';
      return '武藤要　A大学チューター';
    case 1:
      return '脇田康平　B大学チューター';
    case 2:
      return '宮森浩輔　C大学チューター';
    case 3:
      return '葛岡拓真　D大学チューター';
    case 4:
      return '丸山拓哉　E大学チューター';
    case 5:
      return 'アンジェラ１　F大学チューター';
    case 6:
      return 'アンジェラ２　G大学チューター';
    case 7:
      return 'アンジェラ３　H大学チューター';
    case 8:
      return 'アンジェラ４　I大学チューター';
    case 9:
      return 'アンジェラ５　K大学チューター';
  }

  assert(false, 'Failed to generate news headline');
  return 'Failed to generate news headline';
}

List<MaterialColor> getRandomColors(int amount) {
  return List<MaterialColor>.generate(amount, (index) {
    return _myListOfRandomColors[_random.nextInt(_myListOfRandomColors.length)];
  });
}

List<String> getRandomNames(int amount) {
  return wordPairIterator
      .take(amount)
      .map((pair) => capitalizePair(pair))
      .toList();
}

String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}
