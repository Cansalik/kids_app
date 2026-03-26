import 'package:get/get.dart';
import 'package:kids_playroom/ui/counting/controllers/counting_controller.dart';

class CountingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountingController>(
          () => CountingController(),
    );
  }
}
