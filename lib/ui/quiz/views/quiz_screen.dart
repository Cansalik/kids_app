import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/quiz/controller/quiz_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';

class QuizScreen extends StatelessWidget {
  QuizScreen({super.key});

  final QuizController quizController = Get.find<QuizController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 1.8;

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
        title: Text(
          quizController.title.toString().tr,
          style: TextStyle(
              color: AppColor.colorGreen,
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.bold,
              fontFamily: "UrbanistBlack"),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom:true ,
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<QuizController>(
                  id: Constant.idImage,
                  builder: (logic) {
                    return Center(
                        child: logic.catId == 3
                            ? logic.trueItem != null
                                ? Image.asset(
                                    Constant.getAsset() +
                                        logic.trueItem!.image +
                                        ".webp",
                                    height: AppSizes.height_20,
                                  )
                                : const SizedBox()
                            : logic.catId == 4
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          MyApp.flutterTts.stop();
                                          Utils.textToSpeech(
                                            logic.trueItem?.itemNameTts
                                                    .toString() ??
                                                "",
                                            MyApp.flutterTts,
                                          );
                                        },
                                        child: Image.asset(
                                          Constant.getAssetIcons() +
                                              "btn_sound.png",
                                          height: AppSizes.height_16,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                          logic.trueItem?.itemName
                                                  .toString()
                                                  .tr ??
                                              "",
                                          style: TextStyle(
                                              fontSize: AppFontSize.size_22,
                                              fontFamily: "UrbanistBlack",
                                              color: AppColor.colorGray,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  )
                                : const SizedBox());
                  }),
            ),
            Expanded(
              child: GetBuilder<QuizController>(
                  id: Constant.idQuiz,
                  builder: (logic) {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: logic.allQuestionsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (itemWidth / itemHeight),
                          crossAxisSpacing: AppFontSize.size_16,
                          mainAxisSpacing: AppFontSize.size_16),
                      itemBuilder: (BuildContext context, int index) {
                        return items(
                            logic.allQuestionsList[index], index, context);
                      },
                    );
                  }),
            ),
            GetBuilder<QuizController>(builder: (logic) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        logic.onClickPrev();
                      },
                      child: Image.asset(
                        Constant.getAssetIcons() + "btn_prev_150.png",
                        height: AppSizes.height_6_5,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        logic.onClickNext();
                      },
                      child: Image.asset(
                        Constant.getAssetIcons() + "btn_next_150.png",
                        height: AppSizes.height_6_5,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

}

items(ExamQuestionAnswer examQuestionAnswer, int index, BuildContext context) {
  return InkWell(
      onTap: () {
        final quizController = Get.find<QuizController>();
        quizController.checkAnswer(context, itemIndex: index);
      },
      child: GetBuilder<QuizController>(
          id: Constant.idColor,
          builder: (logic) {
            logic.currentColor = logic.containerColors![index];
            logic.txtCurrentColor = logic.txtColors![index];
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: logic.currentColor,
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor.colorGray50,
                        blurRadius: 1.5,
                        spreadRadius: 2.5,
                        offset: Offset(0.5, 1.5))
                  ]),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: logic.catId == 3
                    ? AutoSizeText(
                        examQuestionAnswer.itemName.toString().tr,
                        maxLines: 1,
                        style: TextStyle(
                          color: logic.txtCurrentColor,
                          fontSize: AppFontSize.size_17,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Image.asset(Constant.getAsset() +
                        examQuestionAnswer.image +
                        ".webp"),
              )),
            );
          }));
}
