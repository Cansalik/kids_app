

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/google_ads/custom_ad.dart';
import 'package:kids_playroom/ui/dragsubcategory/controllers/drag_subcategory_controllers.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';

class DragSubcategoryScreen extends StatelessWidget {
  const DragSubcategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.colorTheme,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constant.getAssetIcons() + "btn_back_150.png",
                width: AppSizes.height_4_5),
          ),
        ),
        title: GetBuilder<DragSubcategoryControllers>(builder: (logic) {
          return Text(
              logic.title.toString().tr,
            style: TextStyle(
                color: AppColor.colorGreen,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.bold,
                fontFamily: "UrbanistBlack"),
          );
        }),
      ),

      backgroundColor: AppColor.bg,
      body: SafeArea(
        top: false,
        bottom:true ,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background/bg_home.webp"),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: [_categoryWidget(), const BannerAdClass()],
          ),
        ),
      ),
    );
  }
         }

_categoryWidget() {
  return GetBuilder<DragSubcategoryControllers>(builder: (logic) {
    print(logic.categoryList?.length);
    return Expanded(
      child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: logic.categoryList?.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _categoryItem(context, index);
          }),
    );
  });
}

_categoryItem(BuildContext context, int index) {
  return GetBuilder<DragSubcategoryControllers>(builder: (logic) {
    return InkWell(
      onTap: () {
        logic.moveToNextScreen(index);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.5),
              blurRadius: 6,
            )
          ],
          color: Constant.colorList[index],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5)),
          border: Border.all(color: AppColor.white, width: 3),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(Constant.getAssetDrag() +
                        "${logic.categoryList?[index].categoryImage}.webp"))),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.012),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.5
                    ],
                    colors: [
                      Color(0xffe3e2e2),
                      AppColor.white,
                    ]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    bottomRight: Radius.circular(32),
                    bottomLeft: Radius.circular(2)),
              ),
              child: Center(
                child: Text(
                  logic.categoryList![index].categoryName!.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Angella",
                    fontSize: AppFontSize.size_15,
                    color: Constant.colorList[index],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  });
}
