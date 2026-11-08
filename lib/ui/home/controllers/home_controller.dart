import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/category_table.dart';
import 'package:kids_playroom/google_ads/ad_helper.dart';
import 'package:kids_playroom/in_app_purchase/iap_callback.dart';
import 'package:kids_playroom/in_app_purchase/in_app_purchase_helper.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/preference.dart';
import 'package:kids_playroom/utils/utils.dart';

class HomeController extends GetxController
    with WidgetsBindingObserver,GetSingleTickerProviderStateMixin
    implements IAPCallback {
  List<CategoryTable>? categoryList = [];
  InterstitialAd? interstitialAd;
  bool isInterstitialAdLoaded = false;

  AnimationController? animationController;
  AnimationController? controller;
  Animation<Offset>? animationLeft;
  Animation<Offset>? animationRight;

  @override
  void onInit() {
    _loadInterstitialAd();
    getDataFromDatabase();
    getInAppPurchase();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    animationLeft =
        Tween<Offset>(begin: const Offset(-1.5, 0.0), end: Offset.zero)
            .animate(CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeIn,
        ));

    animationRight =
        Tween<Offset>(begin: const Offset(1.5, 0.0), end: Offset.zero)
            .animate(CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeIn,
        ));

    super.onInit();
  }

  Future<void> getDataFromDatabase() async {
    categoryList = await DataBaseHelper().getCategoryData();
    // iPhone'da "Videolu Öğrenim" (kategori 2) şimdilik gizli.
    if (Platform.isIOS && !Constant.showVideoSectionOnIOS) {
      categoryList?.removeWhere((c) => c.categoryId == 2);
    }
    update([Constant.idHomePage]);
  }

  addBindingObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  removeBindingObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void getInAppPurchase() {
    MyApp.purchaseStreamController.stream.listen((product) {
      try {
        if (product.productID == Utils.getProductId()) {
          Preference.shared.setIsPurchase(true);
        } else {
          Preference.shared.setIsPurchase(false);
        }
      } on Exception catch (e) {
        Preference.shared.setIsPurchase(true);
        Debug.printLog("error", e.toString());
      }
    });
    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
  }


  int _interstitialRetry = 0;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialRetry = 0;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _clearInterstitial();
              // Android'de reklam için gizlenen durum çubuğunu geri getir.
              Utils.showHideStatusBar(isHide: false);
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _clearInterstitial();
              Utils.showHideStatusBar(isHide: false);
              _loadInterstitialAd();
            },
          );

          interstitialAd = ad;
          isInterstitialAdLoaded = true;

          update([Constant.idHomePage]);
        },
        onAdFailedToLoad: (err) {
          Debug.printLog('Failed to load an interstitial ad: ${err.message}');
          // Yükleme başarısız olursa artan aralıklarla tekrar dene (en çok 5 kez).
          if (_interstitialRetry < 5) {
            _interstitialRetry++;
            Future.delayed(Duration(seconds: 30 * _interstitialRetry), () {
              if (!isClosed) _loadInterstitialAd();
            });
          }
        },
      ),
    );
  }

  /// Gösterilmiş/kapatılmış reklam tekrar kullanılmasın.
  void _clearInterstitial() {
    interstitialAd = null;
    isInterstitialAdLoaded = false;
    update([Constant.idHomePage]);
  }

  showAd() async {
    if (interstitialAd != null &&
        isInterstitialAdLoaded &&
        Preference.shared.getInterstitialAdCount() %
                Constant.interstitialCount ==
            0) {
      final ad = interstitialAd!;
      // Aynı reklam iki kez gösterilmesin.
      interstitialAd = null;
      isInterstitialAdLoaded = false;
      Utils.showHideStatusBar();
      await ad.show();
    }
    Preference.shared
        .setInterstitialAdCount(Preference.shared.getInterstitialAdCount() + 1);
  }

  @override
  void dispose() {
    removeBindingObserver();
    try {
      interstitialAd?.dispose();
      interstitialAd = null;
    } catch (ex) {
      Debug.printLog("banner dispose error");
    }
    // interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void onBillingError(error) {
    // TODO: implement onBillingError
  }

  @override
  void onLoaded(bool initialized) {
    // TODO: implement onLoaded
  }

  @override
  void onPending(PurchaseDetails product) {
    // TODO: implement onPending
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    // TODO: implement onSuccessPurchase
  }
}
