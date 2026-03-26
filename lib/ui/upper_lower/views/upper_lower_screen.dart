
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/ui/upper_lower/controller/upper_lower_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';

class UpperLowerScreen extends StatelessWidget {
  const UpperLowerScreen({super.key});

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
        title: GetBuilder<UpperLowerController>(builder: (logic) {
          return Text(
            logic.title ?? "",
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
        child: _upperLowerScreen(),
      ),
    );
  }
}

_upperLowerScreen() {
  return GetBuilder<UpperLowerController>(builder: (logic) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: AppFontSize.size_2
            ),
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
  return GetBuilder<UpperLowerController>(
    assignId: true,
    builder: (logic) {
      return Expanded(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal:AppFontSize.size_10, vertical:AppFontSize.size_8),
            shrinkWrap: true,
            itemCount: logic.que.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 30,
                crossAxisSpacing: 40,
                childAspectRatio: 9 / 20
            ),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Image.asset(
                    logic.upper[logic.que[index]]!,
                  ),
                  const SizedBox(height: 5,),
                  DragTarget(
                    builder: (BuildContext context, List<Object?> candidateData,
                        List<dynamic> rejectedData) {
                      return logic.count.contains(logic.que[index])
                          ? Image.asset(
                        logic.lower[logic.que[index]]!,
                      )
                          : Image.asset(
                        Constant.getAssetDragNumbers()+"blank.webp",
                      );
                    },
                    onWillAcceptWithDetails: (data) {
                      if (logic.lower.keys.firstWhere((element) =>
                      logic.lower[element] == data.data) ==
                          logic.upper.keys.firstWhere((element) =>
                          logic.upper[element] ==
                              logic.upper[logic.que[index]])) {
                        Debug.printLog("accept");
                        return true;
                      } else {
                        Debug.printLog("reject");
                        return false;
                      }
                    },
                    onAcceptWithDetails: (data) => logic.onAccept(data.data, pageIndex, context),
                  ),
                ],
              );
            }),
      );
    },
  );
}

_dragabbles({int? pageIndex}) {
  return GetBuilder<UpperLowerController>(builder: (logic) {
    return Container(
      margin: EdgeInsets.only(bottom:AppFontSize.size_4),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 15,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.35),
          itemBuilder: (BuildContext context, int index) {
            Debug.printLog(logic.lower[logic.options[index]]!.toString());
            return Draggable(
                data: logic.lower[logic.options[index]]!,
                onDragStarted: () {
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
                  logic.lower[logic.options[index]]!,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.068,
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * 0.068,
                ),
                childWhenDragging: const SizedBox(),
                child: logic.count.contains(logic.options[index])
                    ? const SizedBox()
                    : Image.asset(
                  logic.lower[logic.options[index]]!,
                )
            );
          }),
    );
  });
}


