import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/item_table.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/utils.dart';

class QuizController extends GetxController {
  dynamic args = Get.arguments;
  String? title;
  int? subId;
  int? catId;

  List<List<ExamQuestionAnswer>> allQuestionsDataMap = [];
  List<ExamQuestionAnswer> allQuestionsList = [];

  List<ItemTable> learningDataModelArrayList = [];
  List<ExamQuestionAnswer> examQuestionAnswerList = [];
  int currentQuestionIndex = 0;
  Random? random;
  int? correctPosition;

  ExamQuestionAnswer? trueItem;

  Color? defaultColor = AppColor.colorBlueLight;
  Color? defaultTxtColor = AppColor.colorBlueGreen;
  List<Color>? containerColors;
  List<Color>? txtColors;
  int? answerIndex;

  List<ExamQuestionAnswer>? lastSelectedData = [];

  List<List<ExamQuestionAnswer>> selectedDataList = [];
  int currentIndex = 0;
  Color? currentColor;
  Color? txtCurrentColor;



  @override
  Future<void> onInit() async {
    getDataFromArgs();
    await getDataFromDatabase();
    getRandomArray();
    initSound();
    super.onInit();
  }

  getDataFromArgs() {
    if (args != null) {
      if (args[0] != null) {
        title = args[0];
      }
      if (args[1] != null) {
        subId = args[1];
      }
      if (args[2] != null) {
        catId = args[2];
      }
    }
    update([Constant.idQuiz]);
  }

  initSound() {
    if (catId == 3) {
      MyApp.flutterTts.stop();
      Utils.textToSpeech(
          trueItem?.itemNameTts.toString().tr ?? "", MyApp.flutterTts);
    }
  }


  void onClickPrev() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      print(":::onClickPrev::$currentQuestionIndex");

      allQuestionsList = allQuestionsDataMap[currentQuestionIndex];
      trueItem = allQuestionsList.firstWhere((item) => item.isTrue == true);
      MyApp.flutterTts.stop();

      initSound();
      containerColors =
          List<Color>.filled(allQuestionsList.length, defaultColor!);
      txtColors=
      List<Color>.filled(allQuestionsList.length, defaultTxtColor!);

    }

    update([Constant.idColor, Constant.idImage, Constant.idQuiz]);
  }

  onClickNext() {
    if (allQuestionsDataMap.isNotEmpty &&
        currentQuestionIndex < allQuestionsDataMap.length - 1) {
      currentQuestionIndex++;

      print(":::onClickNext::$currentQuestionIndex");
      allQuestionsList = allQuestionsDataMap[currentQuestionIndex];
      trueItem = allQuestionsList.firstWhere((item) => item.isTrue == true);
      MyApp.flutterTts.stop();

      initSound();
      containerColors =
          List<Color>.filled(allQuestionsList.length, defaultColor!);
      txtColors=
      List<Color>.filled(allQuestionsList.length, defaultTxtColor!);
    } else {
      currentQuestionIndex = 0;
      currentQuestionIndex++;
      print(":::onClickNext::$currentQuestionIndex");
      examQuestionAnswerList = allQuestionsDataMap[currentQuestionIndex];
      trueItem =
          examQuestionAnswerList.firstWhere((item) => item.isTrue == true);

      initSound();
      containerColors =
          List<Color>.filled(examQuestionAnswerList.length, defaultColor!);
      txtColors=
      List<Color>.filled(allQuestionsList.length, defaultTxtColor!);

    }

    update([Constant.idColor, Constant.idImage, Constant.idQuiz]);
  }

  Future<void> getDataFromDatabase() async {
    learningDataModelArrayList = await DataBaseHelper().getItemData(subId!);
    update([Constant.idQuiz]);
  }

  void getRandomArray() {
    allQuestionsDataMap.clear(); // Clear the existing map
    random = Random();

    if (learningDataModelArrayList.isNotEmpty) {
      // Check if the learningDataModelArrayList is not empty
      for (int i = 0; i < learningDataModelArrayList.length; i++) {
        examQuestionAnswerList = [];
        correctPosition = random!.nextInt(learningDataModelArrayList.length);
        examQuestionAnswerList.add(ExamQuestionAnswer(
          learningDataModelArrayList[correctPosition!].itemImage ?? "",
          true,
          learningDataModelArrayList[correctPosition!].itemName,
          learningDataModelArrayList[correctPosition!].itemNameTts,
        ));

        Set<String> itemNamesSet = {};
        itemNamesSet
            .add(learningDataModelArrayList[correctPosition!].itemName ?? "");

        while (examQuestionAnswerList.length != 4) {
          int number = random!.nextInt(learningDataModelArrayList.length);
          String itemName = learningDataModelArrayList[number].itemName ?? "";
          if (!itemNamesSet.contains(itemName)) {
            examQuestionAnswerList.add(ExamQuestionAnswer(
              learningDataModelArrayList[number].itemImage ?? "",
              false,
              itemName,
              learningDataModelArrayList[number].itemNameTts,
            ));
            itemNamesSet.add(itemName);
          }
        }
        examQuestionAnswerList.shuffle();
        allQuestionsDataMap.add(examQuestionAnswerList.toList());

        /// Store the question list in the map
        allQuestionsList = allQuestionsDataMap[currentQuestionIndex];
        trueItem = allQuestionsList.firstWhere((item) => item.isTrue == true);
        containerColors =
            List<Color>.filled(allQuestionsList.length, defaultColor!);
        txtColors=
            List<Color>.filled(allQuestionsList.length, defaultTxtColor!);
      }
    }

    update([Constant.idColor, Constant.idImage, Constant.idQuiz]);
  }

  void checkAnswer(BuildContext context, {required int itemIndex}) {
    Color tappedColor =
        allQuestionsList[itemIndex].isTrue ? Colors.green : Colors.red;

    containerColors![itemIndex] = tappedColor;

    currentColor = containerColors![itemIndex];

    Color textColor =
    allQuestionsList[itemIndex].isTrue ? AppColor.colorBlueGreen : AppColor.white;

    txtColors![itemIndex] = textColor;

    txtCurrentColor=txtColors![itemIndex];

    allQuestionsList[itemIndex].isTrue
        ? Utils.showToast(context, "Correct Answer")
        : Utils.showToast(context, "Wrong Answer");
    MyApp.flutterTts.stop();
    allQuestionsList[itemIndex].isTrue
        ? Utils.textToSpeech("Correct Answer", MyApp.flutterTts)
        : Utils.textToSpeech("Wrong Answer", MyApp.flutterTts);
    update([Constant.idColor]);
  }
}

class ExamQuestionAnswer {
  String image;
  String? itemName;
  String? itemNameTts;
  bool isTrue;

  ExamQuestionAnswer(this.image, this.isTrue, this.itemName, this.itemNameTts);
}
