import 'package:get/get.dart';

class VideoSubcategoryController extends GetxController {
  dynamic args = Get.arguments;
  String? title;
  int? subId;

  @override
  void onInit() {
    getDataFromArgs();
    super.onInit();
  }

  List<String> videoCategory = [
    "Alfabe Şarkıları",
    "Sayı Şarkıları",
    "Renk Şarkıları",
    "Hayvan Şarkıları",
    "Şekil Şarkıları",
    "Araç Şarkıları",
    "Meyve Şarkıları",
    "Sebze Şarkıları",
    "Gün Şarkıları",
    "Ay Şarkıları",
    "Kıyafet Şarkıları"
  ];
  List<String> subCategory = [
    "vt_abc.png",
    "vt_number.png",
    "vt_color.png",
    "vt_animal.png",
    "vt_shape.png",
    "vt_vehicle.png",
    "vt_fruit.png",
    "vt_vegetable.png",
    "vt_day.png",
    "vt_month.png",
    "vt_clothes.png"
  ];

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
}
