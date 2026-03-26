import 'package:get/get.dart';
import 'package:kids_playroom/ui/upper_lower/controller/upper_lower_controller.dart';

class UpperLowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpperLowerController>(
          () => UpperLowerController(),
    );
  }
}