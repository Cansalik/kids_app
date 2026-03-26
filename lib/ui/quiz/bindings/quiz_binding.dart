import 'package:get/get.dart';
import 'package:kids_playroom/ui/quiz/controller/quiz_controller.dart';


class QuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(
          () => QuizController(),
    );


  }
}
