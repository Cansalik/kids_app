import 'package:get/get.dart';
import 'package:kids_playroom/ui/items/controllers/item_controller.dart';

class ItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemController>(
      () => ItemController(),
    );
  }
}
