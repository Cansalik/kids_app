import 'package:get/get.dart';
import 'package:kids_playroom/ui/paint/controllers/paint_controller.dart';


class PaintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaintController>(
          () => PaintController(),
    );


  }
}
