
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/missing_numbers/controllers/missing_numbers_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class MissingNumbersScreen extends StatelessWidget {
  const MissingNumbersScreen({super.key});

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
        title: GetBuilder<MissingNumbersController>(builder: (logic) {
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
        child: _missingNumberScreen(),
      ),
    );
  }
}


_missingNumberScreen() {
  return GetBuilder<MissingNumbersController>(builder: (logic) {
    return Flex(
      direction: Axis.vertical,

      children: [
        Expanded(
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
                        _dragTargets(pageIndex: pageIndex),
                        _dragabbles(pageIndex: pageIndex)
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
        ),
      ],
    );
  });
}

_dragTargets({int? pageIndex}) {
  return GetBuilder<MissingNumbersController>(builder: (logic) {
    return Expanded(
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: logic.que.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (BuildContext context, int index) {
            return DragTarget(
              builder: (BuildContext context, List<Object?> candidateData,
                  List<dynamic> rejectedData) {
                return logic.count.contains(logic.que.toList()[index])
                    ? Image.asset(
                  Constant.getAssetDragNumbers()+"${logic.que.toList()[index]}.webp",
                )
                    : Image.asset(
                  Constant.getAssetDragNumbers()+"blank.webp",
                );
              },
              onWillAcceptWithDetails: (data) {
                if (data.data == logic.que.toList()[index]) {
                  return true;
                } else {
                  return false;
                }
              },
              onAcceptWithDetails: (data) => logic.onAccept(data.data, pageIndex, context),
            );
          }),
    );
  });
}

_dragabbles({int? pageIndex}) {
  return GetBuilder<MissingNumbersController>(builder: (logic) {
    return Expanded(
      child: GridView.builder(
          padding:
          EdgeInsets.only(top: AppSizes.height_1),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: logic.options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.35),
          itemBuilder: (BuildContext context, int index) {
            return Draggable(
              data: logic.options[index],
              onDragStarted: () {
                if (logic.count.contains(logic.options[index]) || logic.isDrag!) {
                  Debug.printLog("====true====");
                }
                if (logic.count.contains(logic.options[index]) == false) {
                  MyApp.flutterTts.stop();
                  Utils.textToSpeech(logic.options[index].toString(), MyApp.flutterTts);
                }
                  logic.isDrag = true;
                logic.update();
              },
              onDragEnd: (_) {
                  logic.isDrag = false;
                  logic.update();
              },
              maxSimultaneousDrags: logic.count.contains(logic.options[index]) || logic.isDrag!
                  ? 0
                  : 1,
              feedback: logic.count.contains(logic.options[index])
                  ? const SizedBox()
                  : Image.asset(
                Constant.getAssetDragNumbers()+"${logic.options[index]}.webp",
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.065,
                width: MediaQuery
                    .of(context)
                    .size
                    .height * 0.065,
              ),
              childWhenDragging: Image.asset(
                Constant.getAssetDragNumbers()+"blank.webp",
              ),
              child: logic.count.contains(logic.options[index])
                  ? Image.asset(
                Constant.getAssetDragNumbers()+"blank.webp",
              )
                  : Image.asset(
                Constant.getAssetDragNumbers()+"${logic.options[index]}.webp",
              ),
            );
          }),
    );
  });
}


