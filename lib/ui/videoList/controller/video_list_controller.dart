import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/database/tables/vide_table.dart';

class VideoListController extends GetxController {
  dynamic args = Get.arguments;
  String? title;
  int? subId;
  List<VideoTable>? videoList = [];

  @override
  void onInit() {
    getDataFromArgs();
    getDataFromDatabase(subId!);
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

  getDataFromDatabase(int subId) async {
    videoList = await DataBaseHelper().getVideo(subId);
    print("${videoList?[0].videoId}");
    update();
  }

}
