import 'package:get/get.dart';
import 'package:kids_playroom/ui/quantity/controllers/quantity_controller.dart';

class QuantityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuantityController>(
          () => QuantityController(),
    );
  }
}