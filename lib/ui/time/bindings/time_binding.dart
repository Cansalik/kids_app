
import 'package:get/get.dart';
import 'package:kids_playroom/ui/time/controller/time_controller.dart';

class TimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeController>(
          () => TimeController(),
    );
  }
}
