import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/localization/localizations_delegate.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/preference.dart';
import 'package:kids_playroom/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {

  bool? isSound;
  bool? isMusic;
  LanguageModel? languagesChosenValue;
  List<LanguageModel>? languageList;
  String? prefLanguageCode;
  @override
  void onInit() {
    getLanguageData();

    getPreference();
    super.onInit();
  }

  onTapRemoveAds() {
    Get.toNamed(AppRoutes.proVersion)!.then(
          (value) {
        if (value != null) {
          update([Constant.idIsPurchase]);
          Get.toNamed(AppRoutes.home);
        }
      },
    );
  }
  getLanguageData() {
    prefLanguageCode =
        Preference.shared.getString(Preference.selectedLanguage) ?? 'en';
    languagesChosenValue = languages
        .where((element) => (element.languageCode == prefLanguageCode))
        .toList()[0];
    update([Constant.idChangeLanguage]);
  }

  getPreference() {
    isSound = Preference.shared.getBool(Preference.isSOUND) ?? true;
    isMusic = Preference.shared.getBool(Preference.isMusic) ?? true;
  }

  sound(bool value) {
    isSound = value;
    Preference.shared.setBool(Preference.isSOUND, value);
    update();
  }

  music(bool value) {
    isMusic = value;
    if (isMusic!) {
      Preference.shared.setBool(Preference.isMusic, value);
      getPreference();
      Utils.playAudio();
    } else {
      Preference.shared.setBool(Preference.isMusic, value);

      getPreference();
      Utils.audioPlayer.stop();
    }
    update();
  }

  /*_sound() {
    if (isSound!) {
      Preference.shared.setBool(Preference.isMusic, false);
      getPreference();
      Utils.audioPlayer.stop();
    } else {
      Preference.shared.setBool(Preference.isMusic, true);
      getPreference();
      Utils.playAudio();
    }
  }*/


  Future<void> share() async {
    final size = Get.size;
    await SharePlus.instance.share(
      ShareParams(
        // Sadece bağlantı paylaşılır; iPhone'da ikonlu önizleme kartı olarak görünür.
        uri: Uri.parse(Constant.shareLink),
        // iPad'de paylaşım penceresinin konumu (iPhone'da etkisi yok)
        sharePositionOrigin:
            Rect.fromLTWH(0, 0, size.width, size.height / 2),
      ),
    );
  }

  void sendFeedback() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Constant.emailPath,
      query: encodeQueryParameters(<String, String>{
        'subject': Platform.isAndroid
            ? "txtKidsPreschoolLearningFeedbackAndroid".tr
            : "txtKidsPreschoolLearningFeedbackIOS".tr,
        'body': " "
      }),
    );
    launchUrl(Uri.parse(emailLaunchUri.toString()));

    update();
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
