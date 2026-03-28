import 'package:get/get.dart';
import 'package:kids_playroom/ui/spelling/controller/spelling_controller.dart';

class SpellingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpellingController>(
          () => SpellingController(),
    );


  }
}
