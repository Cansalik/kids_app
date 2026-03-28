import 'package:animate_do/animate_do.dart';
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/tables/item_table.dart';
import 'package:kids_playroom/google_ads/custom_ad.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/ui/items/controllers/item_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class ItemScreen extends StatelessWidget {
  ItemScreen({super.key});

  final ItemController _itemController = Get.find<ItemController>();

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
            _itemController.title.toString().tr,
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
              GetBuilder<ItemController>(
                  id: Constant.idItem,
                  builder: (logic) {
                     return Column(
                       children: [
                         Expanded(
                           child: GridView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount:logic.itemList?.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppFontSize.size_8,
                                mainAxisSpacing: AppFontSize.size_8),
                            itemBuilder: (BuildContext context, int index) {
                              return items(logic.itemList![index],index);
                            },
                    ),
                         ),
                         const BannerAdClass()
                       ],
                     );

                  })
            ],
          ),
        ));
  }


  items(ItemTable itemList, int index) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.singleItem, arguments: index);
        MyApp.flutterTts.stop();
        Utils.textToSpeech(
            itemList.itemNameTts!.tr.toLowerCase(), MyApp.flutterTts);
      },
      child: FadeInUp(
        child: Container(
          padding: EdgeInsets.all(AppSizes.height_2),
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: AppColor.colorGray50,
                    blurRadius: 2,
                    offset: Offset(1.5, 1.5),
                    spreadRadius: 1)
              ]),
          child: Image.asset(Constant.getAsset() + itemList.itemImage + ".webp"),
        ),
      ),
    );
  }
}

Widget Function(BuildContext context, int index, Animation<double> animation)
    animationItemBuilder(Widget Function(int index) child,
            {EdgeInsets padding = EdgeInsets.zero}) =>
        (BuildContext context, int index, Animation<double> animation) =>
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: Padding(
                  padding: padding,
                  child: child(index),
                ),
              ),
            );
