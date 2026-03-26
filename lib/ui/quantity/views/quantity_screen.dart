
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/custom/convert/number_to_word.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/quantity/controllers/quantity_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class QuantityScreen extends StatelessWidget {
  const QuantityScreen({super.key});

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
        title: GetBuilder<QuantityController>(builder: (logic) {
          return Text(
            "${logic.currentQue}/${logic.totalQue}",
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
        bottom: true,
        child: _quantityScreen(),
      ),
    );
  }
}

topBar() {
  return GetBuilder<QuantityController>(builder: (logic) {
    return Container(
      width: AppSizes.fullWidth,
      color: AppColor.colorTheme,
      padding: EdgeInsets.only(
        left: AppSizes.width_3,
        top: AppSizes.height_5,
        bottom: AppSizes.height_1,
      ),
      child: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(Constant.getAssetIcons() + "btn_back_150.png",
                  height: AppSizes.height_5),
            ),
            Center(
              child: Text(
                "${logic.currentQue}/${logic.totalQue}",
                style: TextStyle(
                    color: AppColor.colorGreen,
                    fontSize: AppFontSize.size_16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "UrbanistBlack"),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

_quantityScreen() {
  return GetBuilder<QuantityController>(builder: (logic) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 15, vertical: AppSizes.height_2),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background/bg_background.webp"),
                  fit: BoxFit.fill),
            ),
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: logic.pageController,
              scrollDirection: Axis.horizontal,
              itemCount: logic.totalQue,
              itemBuilder: (BuildContext context, int pageIndex) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        _countItems(pageIndex: pageIndex),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05),
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: logic.accept! ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: AutoSizeText(
                                NumberToWord()
                                    .convert(logic.countAnswer!)
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.theme),
                              ),
                            ),
                          ),
                        ),
                        _countOptions(pageIndex: pageIndex)
                      ],
                    ),
                    Visibility(
                      visible: logic.accept!,
                      child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.2),
                          child: Image.asset(Constant.getAssetDragAnimation() +
                              "animation_success.gif")),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  });
}

_countItems({int? pageIndex}) {
  return GetBuilder<QuantityController>(builder: (logic) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Image.asset(
          Constant.getAssetDragCounting() + "${logic.countAnswer}.webp"),
    );
  });
}

_countOptions({int? pageIndex}) {
  return GetBuilder<QuantityController>(builder: (logic) {
    return Expanded(
        child: GridView.builder(
            padding: EdgeInsets.only(top: AppFontSize.size_10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: logic.options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.35),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  print("object");
                  if (!logic.accept!) {
                    print("object${logic.accept}");

                    MyApp.flutterTts.stop();
                    Utils.textToSpeech(
                            logic.options[index].toString(), MyApp.flutterTts)
                        .then((value) async {
                      if (logic.options[index] == logic.countAnswer) {
                        print("object::${logic.accept}");

                        logic.accept = true;
                        logic.update();
                        MyApp.flutterTts.stop();
                        Utils.textToSpeech("Awesome", MyApp.flutterTts);
                        await Future.delayed(const Duration(milliseconds: 2280),
                            () {
                          if (pageIndex != logic.totalQue! - 1) {
                            logic.pageController!.jumpToPage(pageIndex! + 1);
                            logic.accept = false;
                            logic.currentQue = logic.currentQue! + 1;
                            logic.update();
                            logic.options.clear();
                            logic.getOptions(pageIndex + 1);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CompleteDialog(restartFunction: () {
                                    Navigator.of(context).pop();
                                    logic.accept = false;
                                    logic.currentQue = 1;
                                    logic.update();
                                    logic.pageController!.jumpToPage(0);
                                    logic.options.clear();
                                    logic.getNumbers();
                                    logic.getOptions(0);
                                  });
                                });
                          }
                        });
                        logic.update();
                      }
                    });
                  }
                },
                child: Image.asset(
                  Constant.getAssetDragNumbers() +
                      "${logic.options[index]}.webp",
                ),
              );
            }));
  });
}
