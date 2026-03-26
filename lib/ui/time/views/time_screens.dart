
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/time/controller/time_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
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
        title: GetBuilder<TimeController>(builder: (logic) {
          return Text(
            "${logic.currentQue}/${logic.totalQue}",            style: TextStyle(
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
        child: _timeWidget(),
      ),
    );
  }
}

_timeWidget() {
  return GetBuilder<TimeController>(builder: (logic) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: MediaQuery
                          .of(context)
                          .size
                          .height * 0.065),
                  child: Column(
                    children: [_clocks(pageIndex), _timeOptions()],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  });
}

_clocks(int pageIndex) {
  return GetBuilder<TimeController>(builder: (logic) {
    return Expanded(
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 35,
              mainAxisSpacing: 30,
              childAspectRatio: 0.92),
          itemCount: logic.que.length,
          itemBuilder: (BuildContext context, int index) {
            return _dragTargets(index, pageIndex, context);
          }),
    );
  });
}

_timeOptions() {
  return GetBuilder<TimeController>(builder: (logic) {
    return GridView.builder(
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 70,
            mainAxisSpacing: 25,
            childAspectRatio: 3),
        itemCount: logic.option.length,
        itemBuilder: (BuildContext context, int index) {
          return _draggables(index, context);
        });
  });
}

_dragTargets(int index, int pageIndex, BuildContext context) {
  return GetBuilder<TimeController>(builder: (logic) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DragTarget(
          builder: (BuildContext context, List<Object?> candidateData,
              List<dynamic> rejectedData) {
            return logic.count.contains(
                logic.time.keys.firstWhere((element) => logic.time[element] == logic.que[index]))
                ? Container()
                : Image.asset(logic.que[index]);
          },
          onWillAcceptWithDetails: (data) {
            if (logic.time[data.data] == logic.que[index]) {
              Debug.printLog("logic.accept");
              return true;
            } else {
              Debug.printLog("reject");
              return false;
            }
          },
          onAcceptWithDetails: (data) async {
              logic.accept = true;
              logic.update();
            Debug.printLog("logic.que: ${logic.que[index]}");
            if (logic.count.length < 4) {
                logic.count.add(data.data.toString());
                logic.update();
              MyApp.flutterTts.stop();
              Utils.textToSpeech(logic.timeText[data.data]!, MyApp.flutterTts).then((value) {
                if (logic.count.length == 4) {
                  MyApp.flutterTts.stop();
                  Utils.textToSpeech("Awesome", MyApp.flutterTts);
                }
              });
              await Future.delayed(const Duration(milliseconds: 2280), () {

                  logic.accept = false;
                  logic.update();
              });
            }
            if (logic.count.length == 4) {
              await Future.delayed(const Duration(milliseconds: 1180), () {
                if (pageIndex != logic.totalQue! - 1) {
                  logic.pageController!.jumpToPage(pageIndex + 1);
                    logic.accept = false;
                    logic.currentQue = logic.currentQue! + 1;
                    logic.update();
                  logic.count.clear();
                  logic.option.clear();
                  logic.que.clear();
                  logic.generateTime();
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
                          logic.count.clear();
                          logic.option.clear();
                          logic.que.clear();
                          logic.generateTime();
                        });
                      });
                }
              });
            }
          },
        ),
        Visibility(
          visible: logic.accept! && logic.current == logic.que[index],
          child: Image.asset(
              Constant.getAssetDragAnimation()+"animation_success.gif"),
        )
      ],
    );
  });
}

_draggables(int index, BuildContext context) {
  return GetBuilder<TimeController>(
      builder: (logic) {
        return Draggable(
          maxSimultaneousDrags: logic.accept! || logic.isDrag! ? 0 : 1,
          onDragStarted: () {
              logic.isDrag = true;
              logic.current = logic.time[logic.option[index]];
              Debug.printLog("logic.current: ${logic.current!}");
              logic.update();
          },
          onDragEnd: (_) {
              logic.isDrag = false;
              logic.update();
          },
          data: logic.option[index],
          feedback: logic.count.contains(logic.option[index]) ? Container(
            color: AppColor.transparent,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.33,
          ) : Material(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            elevation: 5,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.058,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.33,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: AppColor.black.withValues(alpha: 0.25), blurRadius: 5)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(colors: logic.optionColor(index)),
              ),
              child: Center(
                child: Text(
                  logic.option[index],
                  style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(
            color: AppColor.transparent,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.33,
          ),
          child: logic.count.contains(logic.option[index])
              ? Container(
            color: AppColor.transparent,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.05,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.33,
          )
              : Material(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.25), blurRadius: 5)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(colors: logic.optionColor(index)),
              ),
              child: Center(
                child: Text(
                  logic.option[index],
                  style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        );
      });
}


