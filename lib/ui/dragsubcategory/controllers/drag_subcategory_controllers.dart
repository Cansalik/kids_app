import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/category_table.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/utils/utils.dart';

class DragSubcategoryControllers extends GetxController {
  List<CategoryTable>? categoryList = [];

  getDataFromDatabase() async {
    categoryList = await DataBaseHelper().getDragCategoryData();
    update();
  }

  dynamic args = Get.arguments;
  String? title;
  int? subId;
  @override
  void onInit() {
    getDataFromArgs();
    getDataFromDatabase();
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
  Future<void> moveToNextScreen(int index) async {

            if (categoryList![index].categoryName == "Numbers") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.numbers, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);    } else if (categoryList![index].categoryName == "Counting") {
                Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.counting, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else if (categoryList![index].categoryName == "Addition" ||
                categoryList![index].categoryName == "Subtraction") {
                  Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.addSubtract, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);

            } else if (categoryList![index].categoryName == "Compare") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.compare, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);

            } else if (categoryList![index].categoryName == "Missing Numbers") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.missingNum, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else if (categoryList![index].categoryName == "Time") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.time, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else if (categoryList![index].categoryName == "Months" ||
                categoryList![index].categoryName == "Days") {
                  Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.month, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);

            } else if (categoryList![index].categoryName == "Quantity") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.quantity, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else if (categoryList![index].categoryName == "Alphabets") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.alphabets, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else if (categoryList![index].categoryName == "Upper & Lower") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.upper, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else if (categoryList![index].categoryName == "Spelling") {
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.spelling, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);
            } else {
              MyApp.flutterTts.stop();
              Utils.textToSpeech(categoryList![index].categoryName!.tr, MyApp.flutterTts);
              Get.toNamed(AppRoutes.dragQuiz, arguments: [
                categoryList![index].categoryName,
                categoryList![index].categoryId
              ]);

            }


  }
}
