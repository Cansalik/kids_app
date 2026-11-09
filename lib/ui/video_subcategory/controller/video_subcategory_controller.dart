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
    "vt_abc.webp",
    "vt_number.webp",
    "vt_color.webp",
    "vt_animal.webp",
    "vt_shape.webp",
    "vt_vehicle.webp",
    "vt_fruit.webp",
    "vt_vegetable.webp",
    "vt_day.webp",
    "vt_month.webp",
    "vt_clothes.webp"
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
