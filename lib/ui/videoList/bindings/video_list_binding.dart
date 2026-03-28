import 'package:get/get.dart';
import 'package:kids_playroom/ui/videoList/controller/video_list_controller.dart';

class VideoListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoListController>(
          () => VideoListController(),
    );
  }
}