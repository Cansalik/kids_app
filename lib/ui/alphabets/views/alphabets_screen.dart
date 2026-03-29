import 'package:floodfill_image/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/alphabets/controllers/alphabets_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class AlphabetsScreen extends StatelessWidget {
  const AlphabetsScreen({super.key});

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
        title: GetBuilder<AlphabetsController>(builder: (logic) {
          return Text(
            logic.title!.tr ?? "",
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
        child: _alphabetsScreen(),
      ),
    );
  }
}

_alphabetsScreen() {
  return GetBuilder<AlphabetsController>(builder: (logic) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 15, vertical: AppFontSize.size_2),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background/bg_background.webp"),
                  fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: logic.pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: logic.alphabetsList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemAlphabet(context, index);
                    },
                  ),
                ),
                _colorPencils()
              ],
            ),
          ),
        ),
      ],
    );
  });
}

_itemAlphabet(BuildContext context, int index) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
        child: Image.asset("assets/background/alpha_frame.webp",
            height: AppSizes.height_66),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 0.2),
          _alphabetColor(context, index),
          _alphabetObject(context, index)
        ],
      )
    ],
  );
}

_colorPencils() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _color("orange"),
      _color("violet"),
      _color("red"),
      _color("green"),
      _color("cyan"),
      _color("pink"),
      _color("blue"),
      _color("yellow"),
    ],
  );
}

_alphabetColor(BuildContext context, int index) {
  return GetBuilder<AlphabetsController>(builder: (logic) {
    final frameWidth = MediaQuery.of(context).size.width * 0.56;
    final letterHeight = MediaQuery.of(context).size.height * 0.225;

    if (logic.isShow!) {
      MyApp.flutterTts.stop();
      Utils.textToSpeech(
          logic.alphabetsList![index].ttsText!, MyApp.flutterTts);
    }
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.055),
      child: SizedBox(
        width: frameWidth,
        height: letterHeight,
        child: Align(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.contain,
            child: FloodFillImage(
              fillColor: logic.currentColor!,
              avoidColor: const [Colors.transparent, Colors.black],
              imageProvider: AssetImage(
                Constant.getAssetDrag() +
                    "${logic.alphabetsList![index].alphaImage}.webp",
              ),
              height: letterHeight.toInt(),
              onFloodFillEnd: (value) async {
                logic.isShow = true;
                logic.update();
                await Future.delayed(const Duration(milliseconds: 1500), () {
                  if (index != logic.alphabetsList!.length - 1) {
                    logic.pageController!.jumpToPage(index + 1);
                    logic.isShow = false;
                    logic.update();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CompleteDialog(restartFunction: () {
                            Navigator.of(context).pop();
                            logic.pageController!.jumpToPage(0);
                            logic.isShow = false;
                            logic.update();
                          });
                        });
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  });
}

_alphabetObject(BuildContext context, int index) {
  return GetBuilder<AlphabetsController>(builder: (logic) {
    final frameWidth = MediaQuery.of(context).size.width * 0.56;
    final objectHeight = MediaQuery.of(context).size.height * 0.21;

    return AnimatedOpacity(
      opacity: !logic.isShow! ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.075),
        child: Column(
          children: [
            SizedBox(
              width: frameWidth,
              height: objectHeight,
              child: Image.asset(
                Constant.getAssetDrag() +
                    "${logic.alphabetsList![index].objectImage}.webp",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 55)
          ],
        ),
      ),
    );
  });
}

_color(String color) {
  return GetBuilder<AlphabetsController>(builder: (logic) {
    return InkWell(
      onTap: () {
        if (!logic.isShow!) {
          logic.currentColor = Utils.colorList[color];
          logic.update();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: logic.currentColor == Utils.colorList[color] ? 10 : 0),
        child: Image.asset(
          "assets/drag assets/colours/$color.webp",
          height: AppSizes.height_5_5,
        ),
      ),
    );
  });
}
