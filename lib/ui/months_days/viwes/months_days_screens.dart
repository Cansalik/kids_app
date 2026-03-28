
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/months_days/controllers/months_days_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class MonthsDaysScreens extends StatelessWidget {
  const MonthsDaysScreens({super.key});

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
        title: GetBuilder<MonthsDaysController>(builder: (logic) {
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
        bottom:true ,
        child: Column(
          children: [
            countWidget()
          ],
        ),
      ),
    );
  }
}

countWidget() {
  return GetBuilder<MonthsDaysController>(builder: (logic) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: AppSizes.height_1),
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
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    dragTargets(pageIndex: pageIndex),
                    dragabbles(pageIndex: pageIndex)
                  ],
                ),
                Visibility(
                  visible: logic.accept!,
                  child: Container(
                    //color: Colur.txtGrey,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .size
                              .height * 0.48),
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

dragTargets({int? pageIndex}) {
  return GetBuilder<MonthsDaysController>(builder: (logic) {
    return Expanded(
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: logic.dragQue.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 25,
            childAspectRatio: 1.55,
          ),
          itemBuilder: (BuildContext context, int index) {
            return DragTarget(
              builder: (BuildContext context, List<Object?> candidateData,
                  List<dynamic> rejectedData) {
                return logic.count.contains(logic.dragQue[index])
                    ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColor.theme,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Image.asset(
                      logic.map[logic.dragQue[index]]!,
                      fit: BoxFit.fill,
                    ))
                    : Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColor.theme,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: AppColor.yellow, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      logic.dragQue[index].toString(),
                      style: const TextStyle(
                          color: AppColor.yellow, fontSize: 24),
                    ),
                  ),
                );
              },
              onWillAcceptWithDetails: (data) {
                Debug.printLog(data.toString());
                if (data.data == logic.dragQue[index]) {
                  Debug.printLog("accept");
                  return true;
                } else {
                  Debug.printLog("reject");
                  return false;
                }
              },
              onAcceptWithDetails: (data) async {
                if (logic.count.length < logic.dragQue.length) {
                    logic.count.add(int.parse(data.data.toString()));
                    logic.update();
                }
                MyApp.flutterTts.stop();
                Utils.textToSpeech(logic.name[data.data]!.tr, MyApp.flutterTts).then((value) {
                  if (logic.count.length == logic.dragQue.length) {
                    Utils.textToSpeech("Awesome".tr, MyApp.flutterTts);
                  }
                });
                if (logic.count.length == logic.dragQue.length) {
                    logic.accept = true;
                    logic.update();
                  await Future.delayed(const Duration(milliseconds: 2280), () {
                    if (pageIndex != logic.totalQue! - 1) {
                      logic.pageController!.jumpToPage(pageIndex! + 1);
                        logic.accept = false;
                        logic.currentQue = logic.currentQue! + 1;
                        logic.update();
                      logic.count.clear();
                      logic.options.clear();
                      logic.dragQue.clear();
                      logic.map.clear();
                      logic.name.clear();
                      logic.monthOption();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CompleteDialog(restartFunction: () {
                              Get.back();
                                logic.accept = false;
                                logic.currentQue = 1;
                                logic.update();
                              logic.pageController!.jumpToPage(0);
                              logic.count.clear();
                              logic.options.clear();
                              logic.dragQue.clear();
                              logic.map.clear();
                              logic.name.clear();
                              logic.monthOption();
                            });
                          });
                    }
                  });
                }
              },
            );
          }),
    );
  });
}

dragabbles({int? pageIndex}) {
  return GetBuilder<MonthsDaysController>(builder: (logic) {
    print("${logic.options.length}");
    return Expanded(
      child: GridView.builder(
          padding:
          EdgeInsets.only(top:AppFontSize.size_10),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: logic.options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 25, childAspectRatio: 1.55),
          itemBuilder: (BuildContext context, int index) {
            return Draggable(
              data: logic.map.keys
                  .firstWhere((element) => logic.map[element] == logic.options[index]),
              feedback: logic.dragChild(index),
              child: logic.dragChild(index),
              childWhenDragging: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
              ),
              onDragStarted: () {
                if (logic.count.contains(logic.map.keys.firstWhere(
                        (element) => logic.map[element] == logic.options[index]))) {
                  MyApp.flutterTts.stop();
                  Utils.textToSpeech(logic.options[index].toString().tr, MyApp.flutterTts);
                }
                  logic.isDrag = true;
                logic.update();
              },
              onDragEnd: (_) {
                  logic.isDrag = false;
                  logic.update();
              },
              maxSimultaneousDrags: logic.count.contains(logic.map.keys.firstWhere(
                      (element) => logic.map[element] == logic.options[index])) || logic.isDrag!
                  ? 0
                  : 1,
            );
          }),
    );
  });
}

