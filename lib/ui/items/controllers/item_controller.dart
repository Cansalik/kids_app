import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/item_table.dart';

import '../../../utils/constant.dart';

class ItemController extends GetxController {
  dynamic args = Get.arguments;
  List<ItemTable>? itemList = [];
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
    update([Constant.idItem]);
  }

  Future<void> getDataFromDatabase() async {
    itemList = await DataBaseHelper().getItemData(subId!);
    print(":: ::: ::: $itemList");
    update([Constant.idItem]);
  }
}
