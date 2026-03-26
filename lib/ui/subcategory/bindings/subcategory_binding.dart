import 'package:get/get.dart';
import 'package:kids_playroom/ui/subcategory/controllers/subcategory_controller.dart';


class SubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubCategoryController>(
          () => SubCategoryController(),
    );
  }
}
