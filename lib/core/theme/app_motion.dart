import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const rewardsEntry = Duration(milliseconds: 1250);
  static const challengeAttention = Duration(milliseconds: 900);
  static const buttonPress = Duration(milliseconds: 120);
  static const tabIndicator = Duration(milliseconds: 320);
  static const tabContent = Duration(milliseconds: 280);
  static const bottomNavPill = Duration(milliseconds: 360);

  static const rewardsCurve = Curves.easeOutCubic;
  static const tabCurve = Curves.easeInOutCubic;

  static const ringStart = 0.08;
  static const ringEnd = 0.88;
  static const badgeStart = 0.18;
  static const badgeEnd = 0.48;
  static const tierStagger = 0.13;
  static const challengeStagger = 0.12;
  static const challengeEnterDuration = 0.42;
  static const activeEarnScale = 1.035;
  static const pressedScale = 0.96;
}
