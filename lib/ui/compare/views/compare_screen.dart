
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/ui/compare/controllers/compare_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

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
        title: GetBuilder<CompareController>(builder: (logic) {
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
            _compareWidget()
          ],
        ),
      ),
    );
  }
}

_compareWidget() {
  return GetBuilder<CompareController>(builder: (logic) {
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
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _question(index: index),
                  _option1(context, index: index),
                  _option2(context, index: index),
                ],
              ),
            );
          },
        ),
      ),
    );
  });
}


_question({int? index}) {
  return GetBuilder<CompareController>(builder: (logic) {
    return Text(
      logic.que!,
      style: const TextStyle(
        color: AppColor.theme,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  });
}

_option1(BuildContext context, {int? index}) {
  return GetBuilder<CompareController>(builder: (logic) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () async {
            if (!logic.show2!) {
                logic.show1 = true;
                logic.update();
              await logic.nextPage(context,index: index);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.85,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: AppColor.black.withValues(alpha: 0.25),
                  )
                ],
                color: AppColor.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Image.asset(
              Constant.getAssetDragCounting()+"${logic.options[0]}.webp",

            ),
          ),
        ),
        if(logic.countAnswer == logic.options[0] && logic.show1!)...{
          _rightAnsAnim()
        },

        if(logic.countAnswer != logic.options[0] && logic.show1!)...{
          _wrongAnsAnim()
        }
      ],
    );
  });
}

_option2(BuildContext context, {int? index}) {
  return GetBuilder<CompareController>(builder: (logic) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        InkWell(
          onTap: () async {
            if (!logic.show1!) {

              logic.show2 = true;
              logic.update();
              await logic.nextPage(context,index: index);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.85,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: AppColor.black.withValues(alpha: 0.25),
                  )
                ],
                color: AppColor.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Image.asset(
              Constant.getAssetDragCounting()+"${logic.options[1]}.webp",

            ),
          ),
        ),
        if(logic.countAnswer == logic.options[1] && logic.show2!)...{
          _rightAnsAnim()
        },

        if(logic.countAnswer != logic.options[1] && logic.show2!)...{
          _wrongAnsAnim()
        }
      ],
    );
  });
}

_rightAnsAnim() {
  return SizedBox(
    height:AppSizes.height_30,
    child: Image.asset(
      Constant.getAssetDragAnimation()+"animation_right.gif",
      fit: BoxFit.fill,
    ),
  );
}

_wrongAnsAnim() {
  return SizedBox(
    height:AppSizes.height_18,
    child: Image.asset(
      Constant.getAssetDragAnimation()+"animation_wrong.gif",
      fit: BoxFit.fill,
    ),
  );
}

