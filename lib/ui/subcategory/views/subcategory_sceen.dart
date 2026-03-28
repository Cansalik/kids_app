import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/tables/sub_category_table.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/ui/subcategory/controllers/subcategory_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/google_ads/custom_ad.dart';

class SubCategoryScreen extends StatelessWidget {
  final SubCategoryController _subCategoryController =
      Get.find<SubCategoryController>();

  SubCategoryScreen({super.key});

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
        title: Text(
          _subCategoryController.title.toString().tr,
          style: TextStyle(
              color: AppColor.colorGreen,
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.bold,
              fontFamily: "UrbanistBlack"),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom:true ,
        child: Stack(
          children: <Widget>[
            Image.asset(Constant.getAssetBackground() + "bg_main.png",
                fit: BoxFit.cover,
                height: AppSizes.fullHeight,
                width: AppSizes.fullWidth),
            GetBuilder<SubCategoryController>(
                id: Constant.idSubCategory,
                builder: (logic) {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: logic.subcategoryList?.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppFontSize.size_12,
                              mainAxisSpacing: AppFontSize.size_16),
                          itemBuilder: (BuildContext context, int index) {
                            return subcategory(logic.subcategoryList![index],
                                logic.catId, logic);
                          },
                        ),
                      ),
                      const BannerAdClass()
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }


  subcategory(
    SubCategoryTable subcategoryList,
    int? catId,
    logic,
  ) {
    return InkWell(
      onTap: () {
        if (catId == 1) {
          Get.toNamed(AppRoutes.items, arguments: [
            subcategoryList.subcategoryName,
            subcategoryList.subcategoryId
          ]);
        } else if (catId == 3 || catId == 4) {
          Get.toNamed(AppRoutes.quiz, arguments: [
            subcategoryList.subcategoryName,
            subcategoryList.subcategoryId,
            catId
          ]);
        }
      },
      child: Image.asset(
          Constant.getAssetSubCategory() + subcategoryList.subcategoryImage),
    );
  }
}
