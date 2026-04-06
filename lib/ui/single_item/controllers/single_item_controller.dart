// import 'package:get/get.dart';
// import 'package:kids_playroom/database/tables/item_table.dart';
// import 'package:kids_playroom/main.dart';
// import 'package:kids_playroom/ui/items/controllers/item_controller.dart';
// import 'package:kids_playroom/utils/constant.dart';
// import 'package:kids_playroom/utils/utils.dart';
//
// class SingleItemController extends GetxController {
//   int index = Get.arguments;
//   List<ItemTable>? itemDataList = Get.find<ItemController>().itemList;
//   // bool launchAnimation = false;
//   RxBool showAnimation = RxBool(false);
//
//   @override
//   void onInit() {
//     // launchAnimation = !launchAnimation;
//     super.onInit();
//   }
//
//     void previousItem() {
//       if (index > 0) {
//         index--;
//
//         MyApp.flutterTts.stop();
//         Utils.textToSpeech(
//             itemDataList![index]
//                 .itemNameTts!.tr
//                 .toLowerCase(),
//             MyApp.flutterTts);
//       }
//       showAnimation.value = !showAnimation.value;
//
//       update([Constant.idSingleItem]);
//     }
//
//   void nextItem() {
//     if (index < itemDataList!.length - 1 ) {
//       index++;
//
//       MyApp.flutterTts.stop();
//       Utils.textToSpeech(
//           itemDataList![index]
//               .itemNameTts!.tr
//               .toLowerCase(),
//           MyApp.flutterTts);
//     }
//     showAnimation.value = !showAnimation.value;
//     update([Constant.idSingleItem]);
//   }
//
//
//
// }
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/alphabets_table.dart';
import 'package:kids_playroom/database/tables/item_table.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/ui/items/controllers/item_controller.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/utils.dart';

class SingleItemController extends GetxController {
  int index = Get.arguments;
  final ItemController itemController = Get.find<ItemController>();
  List<ItemTable>? itemDataList = Get.find<ItemController>().itemList;
  List<AlphabetsTable> alphabetExamples = [];
  var showAnimation = false;

  bool get isAlphabetItem => itemController.subId == 1;

  String? get currentAlphabetObjectAsset {
    if (!isAlphabetItem ||
        itemDataList == null ||
        itemDataList!.isEmpty ||
        alphabetExamples.isEmpty) {
      return null;
    }

    final currentLetter = _extractAlphabetKey(itemDataList![index].itemNameTts);
    if (currentLetter == null) {
      return null;
    }

    AlphabetsTable? match;
    for (final item in alphabetExamples) {
      if (_extractAlphabetKey(item.ttsText) == currentLetter) {
        match = item;
        break;
      }
    }

    if (match?.objectImage == null) {
      return null;
    }

    return "${Constant.getAssetDrag()}${match!.objectImage}.webp";
  }

  String? _extractAlphabetKey(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final apostropheMatch =
        RegExp(r"([A-Za-zÇĞİIÖŞÜçğıöşü])(?=')").firstMatch(value);
    if (apostropheMatch != null) {
      return apostropheMatch.group(1)?.toUpperCase();
    }

    final trailingLetterMatch =
        RegExp(r"([A-Za-zÇĞİIÖŞÜçğıöşü])$").firstMatch(value.trim());
    return trailingLetterMatch?.group(1)?.toUpperCase();
  }

  Future<void> _loadAlphabetExamples() async {
    if (!isAlphabetItem) {
      return;
    }

    alphabetExamples = await DataBaseHelper().getAlphabetsData();
    update([Constant.idSingleItem]);
  }

  void previousItem() {
    if (index > 0) {
      index--;
      showAnimation = !showAnimation;
      animateController;
      MyApp.flutterTts.stop();
      Utils.textToSpeech(
        itemDataList![index].itemNameTts!.tr.toLowerCase(),
        MyApp.flutterTts,
      );
    }

    update([Constant.idSingleItem]);
  }

  void nextItem() {
    if (index < itemDataList!.length - 1) {
      index++;
      showAnimation = !showAnimation;
      animateController;
      MyApp.flutterTts.stop();
      Utils.textToSpeech(
        itemDataList![index].itemNameTts!.tr.toLowerCase(),
        MyApp.flutterTts,
      );
    }

    update([Constant.idSingleItem]);
  }

  AnimationController? animateController;

  @override
  void onInit() {
    showAnimation = !showAnimation;
    _loadAlphabetExamples();
    super.onInit();
  }
}
