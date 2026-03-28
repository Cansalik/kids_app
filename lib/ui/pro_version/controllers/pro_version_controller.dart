import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kids_playroom/in_app_purchase/iap_callback.dart';
import 'package:kids_playroom/in_app_purchase/in_app_purchase_helper.dart';
import 'package:kids_playroom/utils/preference.dart';

import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class ProVersionController extends GetxController implements IAPCallback {
  Map<String, PurchaseDetails>? purchases;
  bool isShowProgress = false;
  bool isSelected = Constant.boolValueTrue;

  /// isSelected true for monthly and false for yearly

  @override
  void onInit() {
    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
    purchases = InAppPurchaseHelper().getPurchases();
    InAppPurchaseHelper().clearTransactions();
    super.onInit();
  }

  onClickPrivacyPolicy() {
    if (Platform.isAndroid) {
      Utils.urlLauncher(Constant.privacyPolicyURL);
    } else {
      Utils.urlLauncher(Constant.privacyPolicyURL);
    }
  }


  onClickRestore() {
    isShowProgress = true;
    update([Constant.idProVersionProgress]);

    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
    Future.delayed(const Duration(seconds: 20), () {
      isShowProgress = false;
      update([Constant.idProVersionProgress]);
      if (!Preference.shared.getIsPurchase()) {
        Utils.showToast(
            Get.context!, "toastNotPurchasedProductCannotRestore".tr);
      }
    });
  }

  onChangePlanSelection(value) {
    isSelected = value;
    update([Constant.idAccessAllFeaturesButtons]);
  }

  onPurchaseClick() {
    isShowProgress = true;
    update([Constant.idProVersionProgress]);
    ProductDetails? product = InAppPurchaseHelper().getProductDetail(Utils.getProductId());
    if (product != null) {
      InAppPurchaseHelper().buySubscription(product, purchases!);
    } else {
      isShowProgress = false;
      update([Constant.idProVersionProgress]);
    }
  }

  @override
  void onBillingError(error) {
    isShowProgress = false;
    update([Constant.idProVersionProgress]);
  }

  @override
  void onLoaded(bool initialized) {}

  @override
  void onPending(PurchaseDetails product) {}

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    Preference.shared.setIsPurchase(true);
    isShowProgress = false;
    update([Constant.idProVersionProgress]);
    Get.back(result: true);
  }
}
