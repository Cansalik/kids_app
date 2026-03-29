import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/ui/single_item/controllers/single_item_controller.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';

class SingleItemScreen extends StatelessWidget {
  const SingleItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Image.asset(
              Constant.getAssetBackground() + "bg_view.png",
              fit: BoxFit.cover,
              height: AppSizes.fullHeight,
              width: AppSizes.fullWidth,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppSizes.width_3,
                right: AppSizes.width_3,
                top: AppSizes.height_5,
                bottom: AppSizes.height_2,
              ),
              child: GetBuilder<SingleItemController>(
                id: Constant.idSingleItem,
                builder: (logic) {
                  final titleText =
                      logic.itemDataList![logic.index].itemName.toString().tr;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          Constant.getAssetIcons() + "btn_back_150.png",
                          height: AppSizes.height_5,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Dance(
                            animate: logic.showAnimation,
                            controller: (controller) =>
                                logic.animateController = controller,
                            child: SizedBox(
                              width: double.infinity,
                              child: AutoSizeText.rich(
                                TextSpan(
                                  children: titleText
                                      .splitMapJoin(
                                        RegExp(r'\d+'),
                                        onMatch: (match) =>
                                            '\u0000${match.group(0)}\u0000',
                                        onNonMatch: (text) => text,
                                      )
                                      .split('\u0000')
                                      .where((part) => part.isNotEmpty)
                                      .map(
                                        (part) => TextSpan(
                                          text: part,
                                          style: TextStyle(
                                            fontFamily:
                                                RegExp(r'^\d+$').hasMatch(part)
                                                    ? "UrbanistBlack"
                                                    : "Angella",
                                            fontWeight:
                                                RegExp(r'^\d+$').hasMatch(part)
                                                    ? FontWeight.w900
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                maxLines: 2,
                                minFontSize: 20,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppFontSize.size_35,
                                  fontFamily: "Angella",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible: logic.index != 0,
                              child: InkWell(
                                onTap: () => logic.previousItem(),
                                child: Image.asset(
                                  Constant.getAssetIcons() + "btn_prev_150.png",
                                  height: AppSizes.height_6_5,
                                ),
                              ),
                            ),
                            Dance(
                              animate: logic.showAnimation,
                              child: Image.asset(
                                Constant.getAsset() +
                                    logic.itemDataList![logic.index].itemImage +
                                    ".webp",
                                height: AppSizes.height_20,
                              ),
                            ),
                            Visibility(
                              visible:
                                  logic.index != logic.itemDataList!.length - 1,
                              child: InkWell(
                                onTap: () => logic.nextItem(),
                                child: Image.asset(
                                  Constant.getAssetIcons() + "btn_next_150.png",
                                  height: AppSizes.height_6_5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
