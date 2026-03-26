import 'package:get/get.dart';
import 'package:kids_playroom/custom/convert/number_to_word.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/utils.dart';

class NumbersController extends GetxController {

  int? current = 1;
  dynamic args = Get.arguments;
  String? title;
  int? subId;

  @override
  void onInit() {
    getDataFromArgs();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(title!, MyApp.flutterTts).then((value) =>
        Utils.textToSpeech(NumberToWord().convert(current!), MyApp.flutterTts));
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
  }


  onTtsClick(int index){
    current = index + 1;
    MyApp.flutterTts.stop();
    Utils.textToSpeech(
        NumberToWord().convert(current!), MyApp.flutterTts);
    update([Constant.idNumbers]);
  }


  @override
  void onClose() {
MyApp.flutterTts.stop();
super.onClose();
  }
}