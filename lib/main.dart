// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kids_playroom/in_app_purchase/in_app_purchase_helper.dart';
import 'package:kids_playroom/localization/locale_constant.dart';
import 'package:kids_playroom/routes/app_pages.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/preference.dart';
import 'package:kids_playroom/utils/utils.dart';

/// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_wrapper.dart'
    show SKPaymentQueueWrapper;

/// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_transaction_wrappers.dart';

import 'package:sizer/sizer.dart';

import 'localization/localizations_delegate.dart';
import 'utils/debug.dart';

Future<void> main() async {
  /// Initialize Shared Preference
  await Preference().instance();
  await Future.delayed(const Duration(milliseconds: 2200));

  /// Initialize Google Mobile Ads
  await _initGoogleMobileAds();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: AppColor.transparent));
  // InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();

  if (Platform.isIOS) {
    final transactions = await SKPaymentQueueWrapper().transactions();

    for (SKPaymentTransactionWrapper element in transactions) {
      await SKPaymentQueueWrapper().finishTransaction(element);
      await SKPaymentQueueWrapper()
          .finishTransaction(element.originalTransaction!);
    }
  }
  InAppPurchaseHelper().initStoreInfo();

  runApp(const MyApp());
}

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final FlutterTts flutterTts = FlutterTts();
  static final StreamController purchaseStreamController =
      StreamController<PurchaseDetails>.broadcast();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool? isMusic;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getPreference();
    if (isMusic!) {
      Utils.playAudio();
    }
    _initGoogleMobileAds();

    super.initState();
  }

  void _getPreference() {
    isMusic = Preference.shared.getBool(Preference.isMusic) ?? true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getPreference();
      if (isMusic!) {
        Utils.audioPlayer.resume();
      }
    } else {
      _getPreference();
      if (isMusic!) {
        Utils.audioPlayer.pause();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        Debug.printLog(
            "didChangeDependencies Preference Revoked", locale.languageCode);
        Debug.printLog("didChangeDependencies GET LOCALE Revoked",
            Get.locale?.languageCode);
        Get.updateLocale(locale);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          navigatorKey: MyApp.navigatorKey,
          debugShowCheckedModeBanner: false,
          color: AppColor.white,
          themeMode: ThemeMode.light,
          locale: const Locale("tr"),
          translations: AppLanguages(),
          fallbackLocale:
              const Locale(Constant.languageTr, Constant.countryCodeTr),
          getPages: AppPages.list,
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 50),
          initialRoute: AppRoutes.home,
        );
      },
    );
  }
}
