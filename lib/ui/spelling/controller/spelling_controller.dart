import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/spelling_table.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class SpellingController extends GetxController{
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  List<SpellingTable>? spellingList = [];

  List<String>? spelling = [];
  List<int>? shuffled = [];
  Map<int, String>? letters = {};

  Set<int>? count = {};
  Set<int>? countOpt = {};
  int? currentIndex;

  String? currentWord;

  dynamic args = Get.arguments;
  String? title;
  int? catId;

  @override
  void onInit() {
    getDataFromArgs();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(title!, MyApp.flutterTts);
    getDataFromDatabase();
    super.onInit();
  }
  getDataFromArgs() {
    if (args != null) {
      if (args[0] != null) {
        title = args[0];
      }
      if (args[1] != null) {
        catId = args[1];
      }
    }
  }
  Future<void> onAccept(
      Object? data, int? pageIndex, BuildContext context, int index) async {
      count!.add(index);
      countOpt!.add(currentIndex!);
      Debug.printLog("count =>$count");
update();
    if (count!.length == spelling!.length) {
      MyApp.flutterTts.stop();
      Utils.textToSpeech(spellingList![pageIndex!].spelling!, MyApp.flutterTts).then(
              (value) => Utils.textToSpeech("Well done", MyApp.flutterTts).then((value) {
            showDialog(
                context: context,
                builder: (context) {
                  return CompleteDialog(restartFunction: () {
                    Navigator.of(context).pop();
                    count!.clear();
                    countOpt!.clear();
                    spelling!.clear();
                    letters!.clear();
                    shuffled!.clear();
                    if (pageIndex == spellingList!.length - 1) {
                      pageController!.jumpToPage(0);
                      getOptions(0);
                    } else {
                      pageController!.jumpToPage(pageIndex + 1);
                      getOptions(pageIndex + 1);
                      update();
                    }
                  },
                    image: "assets/icons/ic_next.webp",);
                });
          }));
    }
  }

  getOptions(int index) {
    currentWord = spellingList![index].spelling!;
    for (var rune in spellingList![index].spelling!.toLowerCase().runes) {
      var char = String.fromCharCode(rune);
      Debug.printLog(char);
      if (char != " ") {
        spelling!.add(char);
      }
    }

    for (int i = 0; i < spelling!.length; i++) {
      letters!.putIfAbsent(i, () => spelling![i]);
    }

    shuffled!.addAll(letters!.keys.toList());
    shuffled!.shuffle();

    Debug.printLog("letters: $letters");
  }

  getDataFromDatabase() async {
    spellingList = await DataBaseHelper().getSpellingData();
    spellingList!.shuffle();
    getOptions(0);
    update();
  }

  getColor(int index) {
    if (index % 3 == 3 || index % 3 == 0) {
      return AppColor.spellingBrown;
    } else if (index % 3 == 2) {
      return AppColor.spellingBlue;
    } else if (index % 3 == 1) {
      return AppColor.spellingRed;
    }
  }

}