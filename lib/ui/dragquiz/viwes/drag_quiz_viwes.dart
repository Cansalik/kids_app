

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/dragquiz/controllers/drag_quiz_controllers.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class DragQuizScreen extends StatelessWidget {
  DragQuizScreen({super.key});

  final DragQuizController dragQuizController = Get.put(DragQuizController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop,result) {
        if(didPop){
          dragQuizController.setPreference();
        }
        // return Future.value(true);
      },
      child: Scaffold(
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
          title: GetBuilder<DragQuizController>(builder: (logic) {
            return Text(
              "${logic.current}/${logic.itemList.length}",
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
          bottom:true ,
          child: Column(
            children: [
              _quizWidget()
            ],
          ),
        ),
      ),
    );
  }
}

_quizWidget() {
  return GetBuilder<DragQuizController>(builder: (logic) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  Constant.getAssetBackground() + "bg_background.webp"),
              fit: BoxFit.fill),
        ),
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: logic.pageController,
          scrollDirection: Axis.horizontal,
          itemCount: logic.itemList.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _dragTarget(context, index: index),
                    SizedBox(height: AppSizes.height_5_5,),
                    _nameText(index),
                    _draggableOptions(context, index: index)
                  ],
                ),
                _animation(context)
              ],
            );
          },
        ),
      ),
    );
  });
}

_animation(BuildContext context) {
  return GetBuilder<DragQuizController>(builder: (logic) {
    return Visibility(
      visible: logic.accept!,
      child: Container(
          padding: EdgeInsets.only(
              bottom: AppSizes.height_1),
          child: Image.asset(
              Constant.getAssetDragAnimation() + "animation_success.gif")),
    );
  });
}

_nameText(int index) {
  return GetBuilder<DragQuizController>(builder: (logic) {
    return AnimatedOpacity(
      opacity: logic.accept! && logic.subId != 17 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Text(
        logic.itemList[index].itemName!.toUpperCase().tr,
        style:  TextStyle(
            fontSize: AppFontSize.size_23,
            fontFamily: "Angella",
            fontWeight: FontWeight.w500,
            color: AppColor.colorBlueGreen),
      ),
    );
  });
}

_draggableOptions(BuildContext context, {int? index}) {
  return GetBuilder<DragQuizController>(builder: (logic) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery
              .of(context)
              .size
              .height * 0.08),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Draggable(
                maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
                onDragStarted: () {
                  logic.isDrag = true;
                  logic.showHint = false;
                  logic.update();
                },
                onDragEnd: (_) {
                  logic.isDrag = false;
                  logic.update();
                  //_setPreference();
                },
                data: logic.options[0],
                feedback: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[0]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                ),
                childWhenDragging: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[0]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[0]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
                  color: logic.options[0] == logic.answer && logic.accept!
                      ? AppColor.transparent
                      : AppColor.white.withValues(alpha: 1),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              Draggable(
                maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
                onDragStarted: () {
                  logic.isDrag = true;
                  logic.showHint = false;
                  logic.update();
                },
                onDragEnd: (_) {
                  logic.isDrag = false;
                  logic.update();
                },
                data: logic.options[1],
                feedback: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[1]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                ),
                childWhenDragging: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[1]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[1]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
                  color: logic.options[1] == logic.answer && logic.accept!
                      ? AppColor.transparent
                      : AppColor.white.withValues(alpha: 1),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              Draggable(
                maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
                onDragStarted: () {
                  logic.isDrag = true;
                  logic.showHint = false;
                  logic.update();
                },
                onDragEnd: (_) {
                  logic.isDrag = false;
                  logic.update();
                },
                data: logic.options[2],
                feedback: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[2]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                ),
                childWhenDragging: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[2]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  Constant.getAssetDrag() + "${logic.options[2]}.webp",
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.13,
                  color: logic.options[2] == logic.answer && logic.accept!
                      ? AppColor.transparent
                      : AppColor.white.withValues(alpha: 1),
                  colorBlendMode: BlendMode.modulate,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: logic.options[0] == logic.answer &&
                    logic.showHint! ,
                child: Transform.rotate(
                  angle: 3.14 / 7,
                  child: Transform.translate(
                    offset: Offset(0, logic.animation!.value),
                    child: Image.asset(
                      Constant.getAssetDragImages() + "hint_hand.webp",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: logic.options[1] == logic.answer &&
                    logic.showHint! ,
                child: Transform.translate(
                  offset: Offset(0, logic.animation!.value),
                  child: Image.asset(
                    Constant.getAssetDragImages() + "hint_hand.webp",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              Visibility(
                visible: logic.options[2] == logic.answer &&
                    logic.showHint!,
                child: Transform.rotate(
                  angle: -3.14 / 7,
                  child: Transform.translate(
                    offset: Offset(0, logic.animation!.value),
                    child: Image.asset(
                      Constant.getAssetDragImages() + "hint_hand.webp",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  });
}

_dragTarget(BuildContext context, {int? index}) {
  return GetBuilder<DragQuizController>(builder: (logic) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppSizes.height_0_3,
      ),
      child: DragTarget(
        builder: (BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,) {
          return logic.subId != 17
              ? Image.asset(
            Constant.getAssetDrag() +
                "${logic.itemList[index!].itemImage}.webp",
            height: MediaQuery
                .of(context)
                .size
                .height * 0.25,
            color: logic.accept!
                ? AppColor.white.withValues(alpha: 1)
                : AppColor.white.withValues(alpha: 0.5),
            colorBlendMode: BlendMode.modulate,
          )
              : logic.accept!
              ? Image.asset(
            Constant.getAssetDrag() +
                "${logic.itemList[index!].itemImage}.webp",
            height: MediaQuery
                .of(context)
                .size
                .height * 0.25,
          )
              : Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.25,
            decoration: BoxDecoration(
                color: AppColor.blackShadow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.25),
                      blurRadius: 8)
                ]),
            child: Center(
              child: Text(
                logic.itemList[index!].itemName!.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: AppColor.white),
              ),
            ),
          );
        },
        onAcceptWithDetails: (data) async {
          print('onAcceptWithDetails');
          logic.accept = true;
          logic.update();
          MyApp.flutterTts.stop();
          if (logic.subId == 17 && logic.itemList[index!].itemName == "Half") {
            Utils.textToSpeech(
                logic.itemList[index].itemName! + "txtDollar".tr,
                MyApp.flutterTts);
          } else if (logic.subId == 17 &&
              logic.itemList[index!].itemName == "Dollar") {
            Utils.textToSpeech(
                "txtOne".tr + logic.itemList[index].itemName!.tr,
                MyApp.flutterTts);
          } else {
            Utils.textToSpeech(
                logic.itemList[index!].itemName!.tr, MyApp.flutterTts);
          }
          await Future.delayed(const Duration(milliseconds: 2280), () async {
            if (index != logic.itemList.length - 1) {
              logic.pageController!.jumpToPage(index + 1);
              logic.current = logic.current! + 1;
              logic.update();
              await logic.generateOptions(index + 1);
                } else {
                  showDialog( 
                    context: context,
                    builder: (context) {
                      return CompleteDialog(restartFunction: () {
                        Navigator.of(context).pop();
                        logic.pageController!.jumpToPage(0);
                        logic.current = 1;
                        logic.update();
                        logic.getDataFromDatabase();
                      });
                    },
                  );
                }
             logic.accept = false;
          });
        },
        onWillAcceptWithDetails: (data) {
          print('onWillAcceptWithDetails ${data.data}');
          print('onWillAcceptWithDetails ${logic.answer}');
          if (data.data == logic.answer) {
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



