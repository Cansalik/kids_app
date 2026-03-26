
import 'package:get/get.dart';
import 'package:kids_playroom/ui/settings/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
    );
  }
}
