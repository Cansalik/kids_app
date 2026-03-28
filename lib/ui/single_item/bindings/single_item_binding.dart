import 'package:get/get.dart';
import 'package:kids_playroom/ui/single_item/controllers/single_item_controller.dart';


class SingleItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingleItemController>(
          () => SingleItemController(),
    );


  }
}
