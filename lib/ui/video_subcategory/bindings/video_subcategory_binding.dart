import 'package:get/get.dart';
import 'package:kids_playroom/ui/video_subcategory/controller/video_subcategory_controller.dart';

class VideoSubcategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoSubcategoryController>(
          () => VideoSubcategoryController(),
    );
  }
}