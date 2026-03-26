import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/tables/category_table.dart';
import 'package:kids_playroom/google_ads/custom_ad.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.colorTheme,
        automaticallyImplyLeading: false,
        title: Text(
          "txtAppName".tr,
          style: TextStyle(
              color: AppColor.colorGreen,
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.bold,
              fontFamily: "UrbanistBlack"),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.settings),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(Constant.getAssetIcons() + "ic_setting.png",
                  height: AppSizes.height_5),
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.white,
      body: SafeArea(
        top: false,
        bottom:true ,
        child: Column(
          children: [
            GetBuilder<HomeController>(
                id: Constant.idHomePage,
                builder: (logic) {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(AppFontSize.size_8_5),
                      itemCount: logic.categoryList!.length,
                      itemBuilder: (context, index) =>
                          categoryItem(logic.categoryList![index], index),
                    ),
                  );
                }),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  topBar() {
    return Container(
      width: AppSizes.fullWidth,
      color: AppColor.colorTheme,
      padding: EdgeInsets.only(
        right: AppSizes.width_3,
        top: AppSizes.height_5,
        bottom: AppSizes.height_1,
      ),
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Text(
                "txtAppName".tr,
                style: TextStyle(
                    color: AppColor.colorGreen,
                    fontSize: AppFontSize.size_16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "UrbanistBlack"),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.settings),
                child: Image.asset(Constant.getAssetIcons() + "ic_setting.png",
                    height: AppSizes.height_5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  categoryItem(CategoryTable categoryList, int index) {
    return GetBuilder<HomeController>(
        id: Constant.idHomePage,
        builder: (logic) {
          return InkWell(
            onTap: () async {
              print("::::::::::::::${categoryList.categoryImage}");
              if (logic.interstitialAd != null &&
                  logic.isInterstitialAdLoaded) {
                logic.showAd();
                if (categoryList.categoryId == 1 ||
                    categoryList.categoryId == 3 ||
                    categoryList.categoryId == 4) {
                  Get.toNamed(AppRoutes.subcategory, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                } else if (categoryList.categoryId == 5) {
                  Get.toNamed(AppRoutes.paint, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                } else if (categoryList.categoryId == 6) {
                  Get.toNamed(AppRoutes.dragSubcategory, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                } else if (categoryList.categoryId == 2) {
                  Get.toNamed(AppRoutes.videoSubcategory, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                }
              } else {
                if (categoryList.categoryId == 1 ||
                    categoryList.categoryId == 3 ||
                    categoryList.categoryId == 4) {
                  Get.toNamed(AppRoutes.subcategory, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                } else if (categoryList.categoryId == 5) {
                  Get.toNamed(AppRoutes.paint, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                } else if (categoryList.categoryId == 6) {
                  Get.toNamed(AppRoutes.dragSubcategory, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                } else if (categoryList.categoryId == 2) {
                  Get.toNamed(AppRoutes.videoSubcategory, arguments: [
                    categoryList.categoryName,
                    categoryList.categoryId,
                  ]);
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: AnimatedBuilder(
                animation: logic.animationController!,
                builder: (context, child) {
                  return SlideTransition(
                    position: index.isOdd
                        ? logic.animationLeft!
                        : logic.animationRight!,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColor.colorGray,
                                  blurRadius: 5,
                                  offset: Offset(0.5, 1.5),
                                  spreadRadius: 0.5)
                            ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(Constant.getAsset() +
                                categoryList.categoryImage))),
                  );
                },
              ),
            ),
          );
        });
  }
}
