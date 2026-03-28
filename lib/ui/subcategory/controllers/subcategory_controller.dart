import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/sub_category_table.dart';
import 'package:kids_playroom/utils/constant.dart';

class SubCategoryController extends GetxController  {
  List<SubCategoryTable>? subcategoryList = [];
  dynamic args = Get.arguments;
  String? title;
  int? catId;



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
        catId = args[1];
      }
    }
  }

  Future<void> getDataFromDatabase() async {
    subcategoryList = await DataBaseHelper().getSubCategoryData();
    print(":: ::: ::: $subcategoryList");
    update([Constant.idSubCategory]);
  }
}
