import 'dart:io';

import 'package:kids_playroom/utils/debug.dart';


class AdHelper {
  static String get bannerAdUnitId {
    if (Debug.googleAd) {
      if (Platform.isAndroid) {
        return "ca-app-pub-8736925209931105/5855744360";
      } else if (Platform.isIOS) {
        return "ca-app-pub-8736925209931105/5855744360";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get interstitialAdUnitId {
    if (Debug.googleAd) {
      if (Platform.isAndroid) {
        return "ca-app-pub-8736925209931105/3518393048";
      } else if (Platform.isIOS) {
        return "ca-app-pub-8736925209931105/3518393048";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

}