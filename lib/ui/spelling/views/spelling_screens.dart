

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/spelling/controller/spelling_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class SpellingScreen extends StatelessWidget {
  const SpellingScreen({super.key});

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
        title: GetBuilder<SpellingController>(builder: (logic) {
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
        bottom:true ,
        child: spellingScreen(),
      ),
    );
  }
}

spellingScreen() {
  return GetBuilder<SpellingController>(builder: (logic) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: AppFontSize.size_2),
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
              itemCount: logic.spellingList!.length,
              itemBuilder: (BuildContext context, int pageIndex) {
                return _itemSpelling(context, pageIndex);
              },
            ),
          ),
        ),
      ],
    );
  });
}

_itemSpelling(BuildContext context, int pageIndex) {
  return GetBuilder<SpellingController>(builder: (logic) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        image(context, pageIndex),
        dragTargets(context, pageIndex),
        draggables(context, pageIndex)
      ],
    );
  });
}

image(BuildContext context, int pageIndex) {
  return GetBuilder<SpellingController>(builder: (logic) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/background/spelling_frame.webp",
          height: MediaQuery
              .of(context)
              .size
              .height * 0.43,
        ),
        Image.asset(
            Constant.getAssetDrag()+"${logic.spellingList![pageIndex].image}.webp",
            height: 230)
      ],
    );
  });
}

dragTargets(BuildContext context, int pageIndex) {
  return GetBuilder<SpellingController>(builder: (logic) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.04),
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: List.generate(
                logic.spelling!.length,
                    (index) =>
                    DragTarget(
                      builder: (BuildContext context,
                          List<dynamic> accepted,
                          List<dynamic> rejected,) {
                        return logic.count!.contains(index)
                            ? Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.052,
                          width: MediaQuery
                              .of(context)
                              .size
                              .height * 0.052,
                          decoration: const BoxDecoration(
                              color: AppColor.spellingGreen,
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              logic.spelling![index].toUpperCase(),
                              style: const TextStyle(
                                  color: AppColor.white, fontSize: 24),
                            ),
                          ),
                        )
                            : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.052,
                          width: MediaQuery
                              .of(context)
                              .size
                              .height * 0.052,
                          decoration: BoxDecoration(
                              color: AppColor.white,
                              border: Border.all(
                                  color: AppColor.greyBorder, width: 1),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      0.0045),
                              decoration: const BoxDecoration(
                                  color: AppColor.grey,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  logic.spelling![index].toUpperCase(),
                                  style: const TextStyle(
                                      color: AppColor.white, fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      onWillAcceptWithDetails: (data) {
                        if (logic.spelling![index] == data.data.toString()) {
                          Debug.printLog("accept");
                          return true;
                        } else {
                          Debug.printLog("reject");
                          return false;
                        }
                      },
                      onAcceptWithDetails: (data) =>
                          logic.onAccept(data, pageIndex, context, index),
                    )),
          ),
        ));
  });
}

draggables(BuildContext context, int pageIndex) {
  return GetBuilder<SpellingController>(builder: (logic) {
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: List.generate(
            logic.shuffled!.length,
                (index) =>
                Draggable(
                  data: logic.letters![logic.shuffled![index]],
                  maxSimultaneousDrags: logic.countOpt!.contains(index) ? 0 : 1,
                  feedback: Material(
                    color: AppColor.transparent,
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.052,
                      width: MediaQuery
                          .of(context)
                          .size
                          .height * 0.052,
                      decoration: BoxDecoration(
                          color: logic.getColor(index),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text(
                          logic.letters![logic.shuffled![index]]!.toUpperCase(),
                          style:
                          const TextStyle(color: AppColor.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    margin:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.052,
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.052,
                  ),
                  onDragStarted: () {
                    logic.currentIndex = index;
                    MyApp.flutterTts.stop();
                     Utils.textToSpeech(
                        logic.letters![logic.shuffled![index]]!.toLowerCase(), MyApp.flutterTts);
                  },
                  child: logic.countOpt!.contains(index)
                      ? Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.052,
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.052,
                  )
                      : Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 5),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.052,
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.052,
                    decoration: BoxDecoration(
                        color: logic.getColor(index),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: AutoSizeText(
                        logic.letters![logic.shuffled![index]]!.toUpperCase(),
                        style: const TextStyle(
                            color: AppColor.white, fontSize: 24),
                      ),
                    ),
                  ),
                )),
      ),
    );
  });
}
