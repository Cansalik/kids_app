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
import 'package:rate_my_app/rate_my_app.dart';

class SettingsController extends GetxController {
  RateMyApp? rateMyApp;

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
  initRateMyApp(BuildContext context) {
    rateMyApp = RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 7,
        minLaunches: 10,
        remindDays: 7,
        remindLaunches: 10,
        googlePlayIdentifier: Constant.googlePlayIdentifier,
        appStoreIdentifier: Constant.appStoreIdentifier);

    if (Platform.isIOS) {
      rateMyApp!.init().then((_) {
        if (rateMyApp!.shouldOpenDialog) {
          rateMyApp!.showRateDialog(
            context,
            title: 'Rate this app',
            message:
                'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
            rateButton: 'RATE',
            noButton: 'NO THANKS',
            laterButton: 'MAYBE LATER',
            listener: (button) {
              switch (button) {
                case RateMyAppDialogButton.rate:
                  break;
                case RateMyAppDialogButton.later:
                  break;
                case RateMyAppDialogButton.no:
                  break;
              }

              return true;
            },
            ignoreNativeDialog: Platform.isAndroid,
            dialogStyle: const DialogStyle(),
            onDismissed: () =>
                rateMyApp!.callEvent(RateMyAppEventType.laterButtonPressed),
          );

          rateMyApp!.showStarRateDialog(
            context,
            title: 'Rate this app',
            message:
                'You like this app ? Then take a little bit of your time to leave a rating :',
            actionsBuilder: (context, stars) {
              return [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    await rateMyApp!
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            ignoreNativeDialog: Platform.isAndroid,
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: const StarRatingOptions(),
            onDismissed: () =>
                rateMyApp!.callEvent(RateMyAppEventType.laterButtonPressed),
          );
        }
      });
    }
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

  rate(BuildContext context) {
    if (Platform.isIOS) {
      rateMyApp!.showRateDialog(context);
    } else {
      rateMyApp!.launchStore();
    }
  }

  Future<void> share() async {
    await SharePlus.instance.share(
     ShareParams(title:"txtShareDesc".tr + Constant.shareLink,
      subject: "txtKidsPreschoolLearning".tr,)
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
