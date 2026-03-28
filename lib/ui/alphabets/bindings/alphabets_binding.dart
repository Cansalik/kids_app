import 'package:get/get.dart';
import 'package:kids_playroom/ui/alphabets/controllers/alphabets_controller.dart';

class AlphabetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlphabetsController>(
          () => AlphabetsController(),
    );
  }}
