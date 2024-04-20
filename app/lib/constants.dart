// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:staked_steps/utils/common_utils.dart';

enum Screens { CHALLENGES, PROFILE }

enum Pages { home, login }

enum ChallengesType { PUBLIC, USER_ONGOING, USER_COMPLETED }

class CustomColors {
  final Color LIGHT = (Colors.green[50])!;
  final Color PRIMARY_LIGHT = (Colors.green[100])!;
  final Color PRIMARY = (Colors.green[200])!;
  final Color SECONDARY = (Colors.green[300])!;
}

const zerothAddress = '0x0000000000000000000000000000000000000000';
const token = 'ETH';

final currentChain = fetchBaseSepolia();
const openseaChain = 'base-sepolia';
const openseaUrl = 'https://testnets.opensea.io/assets/$openseaChain';

String toTitleCase(String text) {
  if (text == null || text.isEmpty) {
    return '';
  }

  return text.split(' ').map((word) {
    if (word.isEmpty) {
      return '';
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

String capitalize(String text) {
  if (text == null || text.isEmpty) {
    return '';
  }

  return text.substring(0, 1).toUpperCase() + text.substring(1);
}
