import 'package:get/get.dart';
import 'package:kids_playroom/ui/dragquiz/controllers/drag_quiz_controllers.dart';

class DragQuizBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DragQuizController>(
      () => DragQuizController(),
    );
  }
}
