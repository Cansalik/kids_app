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
    print(":: ::: ::: $categoryList");
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


  void _loadInterstitialAd() {
    print("::::::object");
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();

              _loadInterstitialAd();
            },
          );

          interstitialAd = ad;
          isInterstitialAdLoaded = true;

          update([Constant.idHomePage]);
        },
        onAdFailedToLoad: (err) {
          Debug.printLog('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  showAd() async {
    if (interstitialAd != null &&
        Preference.shared.getInterstitialAdCount() %
                Constant.interstitialCount ==
            0) {
      Utils.showHideStatusBar();
      await interstitialAd!.show();
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
