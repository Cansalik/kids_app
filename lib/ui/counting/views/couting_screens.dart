
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/counting/controllers/counting_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class CountingScreen extends StatelessWidget {
  const CountingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountingController>(
        id: Constant.idCounting,
        builder: (logic) {
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
              title: GetBuilder<CountingController>(builder: (logic) {
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
            backgroundColor: AppColor.lightBG,
            body: SafeArea(
              top: false,
              bottom:true ,
              child: Column(
                children: [_countWidget()],
              ),
            ),
          );
        });
  }

  _countWidget() {
    return GetBuilder<CountingController>(builder: (logic) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(Constant.getAssetDragCounting() +
                                "${logic.countAnswer}.webp")),
                      ),
                      _dragTarget(context, index: index),
                      _draggableOptions(context, index: index)
                    ],
                  ),
                  Visibility(
                    visible: logic.accept!,
                    child: Container(
                        //color: AppColor.txtGrey,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.48),
                        child: Image.asset(
                            Constant.getAssetDragAnimation()+"animation_success.gif")),
                  )
                ],
              );
            },
          ),
        ),
      );
    });
  }


  _draggableOptions(BuildContext context, {int? index}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _option1(context),
          _option2(context),
          _option3(context),
          _option4(context),
        ],
      ),
    );
  }

  _option1(BuildContext context) {
    return GetBuilder<CountingController>(builder: (logic) {
      return Draggable(
        maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
        onDragStarted: () {
          MyApp.flutterTts.stop();
          Utils.textToSpeech(logic.options[0].toString(), MyApp.flutterTts);
          logic.isDrag = true;
          logic.update();
        },
        onDragEnd: (_) {
          logic.isDrag = false;
          logic.update();
        },
        data: logic.options[0],
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
                logic.options[0].toString(),
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
        child: logic.accept! && logic.countAnswer == logic.options[0]
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
                    logic.options[0].toString(),
                    style: const TextStyle(fontSize: 24, color: AppColor.white),
                  ),
                ),
              ),
      );
    });
  }

  _option2(BuildContext context) {
    return GetBuilder<CountingController>(builder: (logic) {
      return Draggable(
        maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
        onDragStarted: () {
          MyApp.flutterTts.stop();
          Utils.textToSpeech(logic.options[1].toString(), MyApp.flutterTts);
          logic.isDrag = true;
        },
        onDragEnd: (_) {
          logic.isDrag = false;
          logic.update();
        },
        data: logic.options[1],
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
                logic.options[1].toString(),
                style: const TextStyle(fontSize: 24, color: AppColor.white),
              ),
            ),
          ),
        ),
        childWhenDragging: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
        ),
        child: logic.accept! && logic.countAnswer == logic.options[1]
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
                    logic.options[1].toString(),
                    style: const TextStyle(fontSize: 24, color: AppColor.white),
                  ),
                ),
              ),
      );
    });
  }

  _option3(BuildContext context) {
    return GetBuilder<CountingController>(builder: (logic) {
      return Draggable(
        maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
        onDragStarted: () {
          MyApp.flutterTts.stop();
          Utils.textToSpeech(logic.options[2].toString(), MyApp.flutterTts);
          logic.isDrag = true;
        },
        onDragEnd: (_) {
          logic.isDrag = false;
          logic.update();
        },
        data: logic.options[2],
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
                logic.options[2].toString(),
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
        child: logic.accept! && logic.countAnswer == logic.options[2]
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
                    logic.options[2].toString(),
                    style: const TextStyle(fontSize: 24, color: AppColor.white),
                  ),
                ),
              ),
      );
    });
  }

  _option4(BuildContext context) {
    return GetBuilder<CountingController>(builder: (logic) {
      return Draggable(
        maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
        onDragStarted: () {
          MyApp.flutterTts.stop();
          Utils.textToSpeech(logic.options[3].toString(), MyApp.flutterTts);
          logic.isDrag = true;
        },
        onDragEnd: (_) {
          logic.isDrag = false;
          logic.update();
        },
        data: logic.options[3],
        feedback: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.white, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: AppColor.lightBlueSquare),
            child: Center(
              child: Text(
                logic.options[3].toString(),
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
        child: logic.accept! && logic.countAnswer == logic.options[3]
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
                    color: AppColor.lightBlueSquare),
                child: Center(
                  child: Text(
                    logic.options[3].toString(),
                    style: const TextStyle(fontSize: 24, color: AppColor.white),
                  ),
                ),
              ),
      );
    });
  }

  _dragTarget(BuildContext context, {int? index}) {
    return GetBuilder<CountingController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.height_0_5),
        child: DragTarget(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: AppColor.greySquare),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.white, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: logic.answerColor()),
                    child: Center(
                      child: Text(
                        logic.countAnswer!.toString(),
                        style: const TextStyle(
                            fontSize: 24, color: AppColor.white),
                      ),
                    ),
                  );
          },
          onAcceptWithDetails: (data) async {
            logic.accept = true;

            await Future.delayed(const Duration(milliseconds: 2280), () {
              if (index != logic.totalQue! - 1) {
                logic.pageController!.jumpToPage(index! + 1);

                logic.accept = false;
                logic.currentQue = logic.currentQue! + 1;

                logic.options.clear();
                logic.getOptions(index + 1);
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
              logic.accept = false;
            });
          },
          onWillAcceptWithDetails: (data) {
            if (data.data == logic.countAnswer) {
              Debug.printLog("accept");
              return true;
            } else {
              Debug.printLog("reject");
              return false;
            }
          },
        ),
      );
    });
  }
}
