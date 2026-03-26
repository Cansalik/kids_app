import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/add_subtract/controllers/add_subtract_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class AddSubtractScreen extends StatelessWidget {
  const AddSubtractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
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
        title: GetBuilder<AddSubtractController>(builder: (logic) {
          return Text(
            "${logic.currentQuestion}/${logic.totalQuestions}",
            style: TextStyle(
                color: AppColor.colorGreen,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.bold,
                fontFamily: "UrbanistBlack"),
          );
        }),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: addWidget(),
      ),
    );
  }
}

addWidget() {
  return GetBuilder<AddSubtractController>(
      id: Constant.idAdd,
      builder: (logic) {
        return Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  itemCount: logic.totalQuestions,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width: MediaQuery.of(context).size.height *
                                        0.08,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.white, width: 3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: AppColor.pinkSquare),
                                    child: Center(
                                      child: Text(
                                        logic.num1!.toString(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: AppColor.white),
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    logic.subId == 14
                                        ? "assets/icons/ic_minus.webp"
                                        : "assets/icons/ic_add.webp",
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width: MediaQuery.of(context).size.height *
                                        0.08,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.white, width: 3),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: AppColor.greenSquare),
                                    child: Center(
                                      child: Text(
                                        logic.num2!.toString(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: AppColor.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/icons/ic_equal.webp",
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    width: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  dragTarget(context, index: index)
                                ],
                              ),
                            ),
                            draggableOptions(context, index: index)
                          ],
                        ),
                        Visibility(
                          visible: logic.accept!,
                          child: Container(
                              //color: AppColor.txtGrey,
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.48),
                              child: Image.asset(
                                  "assets/animation/animation_success.gif")),
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

dragTarget(BuildContext context, {int? index}) {
  return GetBuilder<AddSubtractController>(builder: (logic) {
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return !logic.accept!
            ? Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.white, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: AppColor.greySquare),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.white, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: logic.answerColor()),
                child: Center(
                  child: Text(
                    logic.answer!.toString(),
                    style: const TextStyle(fontSize: 24, color: AppColor.white),
                  ),
                ),
              );
      },
      onAcceptWithDetails: (data) async {
        MyApp.flutterTts.stop();
        Utils.textToSpeech("Awesome", MyApp.flutterTts);
        logic.accept = true;
        logic.update();
        await Future.delayed(const Duration(milliseconds: 2280), () {
          if (index != logic.totalQuestions! - 1) {
            logic.pageController!.jumpToPage(index! + 1);
            logic.generateNumbers();
            logic.currentQuestion = logic.currentQuestion! + 1;
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return CompleteDialog(restartFunction: () {
                    Navigator.of(context).pop();
                    logic.generateNumbers();
                    logic.currentQuestion = 1;
                    logic.update();
                    logic.pageController!.jumpToPage(0);
                  });
                });
          }
          logic.accept = false;
          logic.update();
        });
      },
      onWillAcceptWithDetails: (data) {
        if (data.data == logic.answer) {
          Debug.printLog("logic.accept");
          return true;
        } else {
          Debug.printLog("reject");
          return false;
        }
      },
    );
  });
}

draggableOptions(BuildContext context, {int? index}) {
  return Container(
    margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.08),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        option1(context),
        option2(context),
        option3(context),
      ],
    ),
  );
}

option1(BuildContext context) {
  return GetBuilder<AddSubtractController>(builder: (logic) {
    return Draggable(
      maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
      onDragStarted: () {
        MyApp.flutterTts.stop();
        Utils.textToSpeech(logic.options![0].toString(), MyApp.flutterTts);
        logic.isDrag = true;
      },
      onDragEnd: (_) {
        logic.isDrag = false;
        logic.update();
      },
      data: logic.options![0],
      feedback: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.white, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: AppColor.violetSquare),
          child: Center(
            child: Text(
              logic.options![0].toString(),
              style: const TextStyle(
                fontSize: 24,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
      ),
      child: logic.accept! && logic.answer == logic.options![0]
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.white, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: AppColor.violetSquare),
              child: Center(
                child: Text(
                  logic.options![0].toString(),
                  style: const TextStyle(fontSize: 24, color: AppColor.white),
                ),
              ),
            ),
    );
  });
}

option2(BuildContext context) {
  return GetBuilder<AddSubtractController>(builder: (logic) {
    return Draggable(
      maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
      onDragStarted: () {
        logic.isDrag = true;
        logic.update();
        MyApp.flutterTts.stop();
        Utils.textToSpeech(logic.options![1].toString(), MyApp.flutterTts);
      },
      onDragEnd: (_) {
        logic.isDrag = false;
        logic.update();
      },
      data: logic.options![1],
      feedback: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.white, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: AppColor.redSquare),
          child: Center(
            child: Text(
              logic.options![1].toString(),
              style: const TextStyle(fontSize: 24, color: AppColor.white),
            ),
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
      ),
      child: logic.accept! && logic.answer == logic.options![1]
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.white, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: AppColor.redSquare),
              child: Center(
                child: Text(
                  logic.options![1].toString(),
                  style: const TextStyle(fontSize: 24, color: AppColor.white),
                ),
              ),
            ),
    );
  });
}

option3(BuildContext context) {
  return GetBuilder<AddSubtractController>(builder: (logic) {
    return Draggable(
      maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
      onDragStarted: () {
        logic.isDrag = true;
        logic.update();
        MyApp.flutterTts.stop();
        Utils.textToSpeech(logic.options![2].toString(), MyApp.flutterTts);
      },
      onDragEnd: (_) {
        logic.isDrag = false;
        logic.update();
      },
      data: logic.options![2],
      feedback: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.white, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: AppColor.blueSquare),
          child: Center(
            child: Text(
              logic.options![2].toString(),
              style: const TextStyle(
                fontSize: 24,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
      ),
      child: logic.accept! && logic.answer == logic.options![2]
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor.white, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: AppColor.blueSquare),
              child: Center(
                child: Text(
                  logic.options![2].toString(),
                  style: const TextStyle(fontSize: 24, color: AppColor.white),
                ),
              ),
            ),
    );
  });
}
