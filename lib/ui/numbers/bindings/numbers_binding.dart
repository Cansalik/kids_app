import 'package:get/get.dart';
import 'package:kids_playroom/ui/numbers/controllers/numbers_controller.dart';

class NumbersBinding extends Bindings {
  @override
  void dependencies()  {
    Get.lazyPut<NumbersController>(
          () => NumbersController(),
    );
  }
}
