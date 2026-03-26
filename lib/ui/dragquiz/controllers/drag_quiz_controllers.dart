import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/drag_item_table.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/preference.dart';

class DragQuizController extends GetxController with GetSingleTickerProviderStateMixin  {

  dynamic args = Get.arguments;
  String? title;
  int? subId;
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  String? answer;
  bool? accept = false;
  int? current = 1;
  bool? isDrag = false;
  List<DragItemTable> itemList = [];
  List<String> options = [];

  String? currentItem;

  AnimationController? animationController;
  Animation<double>? animation;
  bool? showHint = false;

  @override
  Future<void> onInit() async {
    getDataFromArgs();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animationController!.repeat();
    animation = Tween<double>(begin: 0, end: -250).animate(animationController!)
      ..addListener(() {
        update();
      });
    getPreference();

   await getDataFromDatabase();
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
    }
    update();
  }

  getDataFromDatabase() async {
    itemList = await DataBaseHelper().getDragItemData(subId!);
    itemList.shuffle();
    await generateOptions(0);
    update();
  }

  generateOptions(int index) {
    currentItem = itemList[index].itemName;

    int n1;
    int n2;

    do {
      do {
        n1 = Random().nextInt(itemList.length);
        do {
          n2 = Random().nextInt(itemList.length);
        } while (n2 == index);
      } while (n1 == index);
    } while (n1 == n2);

    Debug.printLog("n1: $n1");
    Debug.printLog("n2: $n2");
    Debug.printLog("index: $index");
    Set<String> opt = {};
    answer = itemList[index].itemImage!;
    opt.add(itemList[index].itemImage!);
    opt.add(itemList[n1].itemImage!);
    opt.add(itemList[n2].itemImage!);
    Debug.printLog(opt.toString());

    options = opt.toList();
    options.shuffle();
    Debug.printLog("options: $options");
    update();
  }

  getPreference() {
    if (subId == 1) {
      var count = Preference.shared.getBool(Preference.hintAnimal) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }
    } else if (subId == 2) {
      var count = Preference.shared.getBool(Preference.hintFruits) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }
    } else if (subId == 3) {
      var count = Preference.shared.getBool(Preference.hintBirds) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }
    } else if (subId == 4) {
      var count = Preference.shared.getBool(Preference.hintShapes) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }
    } else if (subId == 5) {
      var count = Preference.shared.getBool(Preference.hintEducation) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }
    } else if (subId == 6) {
      var count = Preference.shared.getBool(Preference.hintVehicles) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }}else if (subId == 17) {
      var count = Preference.shared.getBool(Preference.hintMoney) ?? true;
      Debug.printLog(count.toString() + subId.toString());
      if (count) {
        showHint = count;
      }
    }
    update();
  }

  setPreference() {
    if (subId == 1) {
      Preference.shared.setBool(Preference.hintAnimal, showHint!);
    } else if (subId == 2) {
      Preference.shared.setBool(Preference.hintFruits, showHint!);
    } else if (subId == 3) {
      Preference.shared.setBool(Preference.hintBirds, showHint!);
    } else if (subId == 4) {
      Preference.shared.setBool(Preference.hintShapes, showHint!);
    } else if (subId == 5) {
      Preference.shared.setBool(Preference.hintEducation, showHint!);
    } else if (subId == 6) {
      Preference.shared.setBool(Preference.hintVehicles, showHint!);
    }else if (subId == 17) {
      Preference.shared.setBool(Preference.hintMoney, showHint!);
    }
  }

  @override
  void onClose() {
    animationController?.dispose();
    super.onClose();
  }

}
