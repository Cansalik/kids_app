import 'package:get/get.dart';
import 'package:kids_playroom/ui/months_days/controllers/months_days_controller.dart';

class MonthsDaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MonthsDaysController>(
          () => MonthsDaysController(),
    );
  }
}