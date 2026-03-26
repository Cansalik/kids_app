
import 'package:get/get.dart';
import 'package:kids_playroom/ui/compare/controllers/compare_controller.dart';

class CompareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompareController>(
          () => CompareController(),
    );
  }}
