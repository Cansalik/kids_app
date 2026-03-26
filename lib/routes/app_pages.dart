import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kids_playroom/ui/add_subtract/bindings/add_subtract_bindings.dart';
import 'package:kids_playroom/ui/add_subtract/views/add_subtract_screen.dart';
import 'package:kids_playroom/ui/alphabets/bindings/alphabets_binding.dart';
import 'package:kids_playroom/ui/alphabets/views/alphabets_screen.dart';
import 'package:kids_playroom/ui/compare/bindings/compare_binding.dart';
import 'package:kids_playroom/ui/compare/views/compare_screen.dart';
import 'package:kids_playroom/ui/counting/bindings/counting_bindings.dart';
import 'package:kids_playroom/ui/counting/views/couting_screens.dart';
import 'package:kids_playroom/ui/dragquiz/bindings/drag_quiz_bindings.dart';
import 'package:kids_playroom/ui/dragquiz/viwes/drag_quiz_viwes.dart';
import 'package:kids_playroom/ui/dragsubcategory/bindings/drag_subcategory_bindings.dart';
import 'package:kids_playroom/ui/dragsubcategory/viwes/drag_subcategory_viwes.dart';
import 'package:kids_playroom/ui/home/bindings/home_binding.dart';
import 'package:kids_playroom/ui/home/views/home_screen.dart';
import 'package:kids_playroom/ui/items/bindings/item_binding.dart';
import 'package:kids_playroom/ui/items/views/items_screen.dart';
import 'package:kids_playroom/ui/missing_numbers/bindings/missing_numbers_bindings.dart';
import 'package:kids_playroom/ui/missing_numbers/views/missing_numbers_screens.dart';
import 'package:kids_playroom/ui/months_days/bindings/months_days_bindings.dart';
import 'package:kids_playroom/ui/months_days/viwes/months_days_screens.dart';
import 'package:kids_playroom/ui/numbers/bindings/numbers_binding.dart';
import 'package:kids_playroom/ui/numbers/views/numbers_screens.dart';
import 'package:kids_playroom/ui/paint/bindings/paint_binding.dart';
import 'package:kids_playroom/ui/paint/views/paint_screen.dart';
import 'package:kids_playroom/ui/pro_version/bindings/pro_version_binding.dart';
import 'package:kids_playroom/ui/pro_version/views/pro_version_screen.dart';
import 'package:kids_playroom/ui/quantity/bindings/quantity_binding.dart';
import 'package:kids_playroom/ui/quantity/views/quantity_screen.dart';
import 'package:kids_playroom/ui/quiz/bindings/quiz_binding.dart';
import 'package:kids_playroom/ui/quiz/views/quiz_screen.dart';
import 'package:kids_playroom/ui/settings/bindings/settings_binding.dart';
import 'package:kids_playroom/ui/settings/views/settings_screen.dart';
import 'package:kids_playroom/ui/single_item/bindings/single_item_binding.dart';
import 'package:kids_playroom/ui/single_item/views/single_item_screen.dart';
import 'package:kids_playroom/ui/spelling/bindings/spelling_bindings.dart';
import 'package:kids_playroom/ui/spelling/views/spelling_screens.dart';
import 'package:kids_playroom/ui/subcategory/bindings/subcategory_binding.dart';
import 'package:kids_playroom/ui/subcategory/views/subcategory_sceen.dart';
import 'package:kids_playroom/ui/time/bindings/time_binding.dart';
import 'package:kids_playroom/ui/time/views/time_screens.dart';
import 'package:kids_playroom/ui/upper_lower/bindings/upper_lower_binding.dart';
import 'package:kids_playroom/ui/upper_lower/views/upper_lower_screen.dart';
import 'package:kids_playroom/ui/videoList/bindings/video_list_binding.dart';
import 'package:kids_playroom/ui/videoList/views/video_list_screen.dart';
import 'package:kids_playroom/ui/video_player/bindings/video_player_binding.dart';
import 'package:kids_playroom/ui/video_player/views/video_player_screen.dart';
import 'package:kids_playroom/ui/video_subcategory/bindings/video_subcategory_binding.dart';
import 'package:kids_playroom/ui/video_subcategory/views/video_subcategory_screen.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.subcategory,
      page: () => SubCategoryScreen(),
      binding: SubCategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.items,
      page: () => ItemScreen(),
      binding: ItemBinding(),
    ),
    GetPage(
      name: AppRoutes.singleItem,
      page: () => SingleItemScreen(),
      binding: SingleItemBinding(),
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => QuizScreen(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.paint,
      page: () => PaintScreen(),
      binding: PaintBinding(),
    ),
    GetPage(
      name: AppRoutes.dragSubcategory,
      page: () => DragSubcategoryScreen(),
      binding: DragSubcategoryBindings(),
    ), GetPage(
      name: AppRoutes.dragQuiz,
      page: () => DragQuizScreen(),
      binding: DragQuizBindings(),
    ),

    GetPage(
      name: AppRoutes.numbers,
      page: () => NumbersScreen(),
      binding: NumbersBinding(),
    ),GetPage(
      name: AppRoutes.counting,
      page: () => CountingScreen(),
      binding: CountingBinding(),
    ),GetPage(
      name: AppRoutes.addSubtract,
      page: () => AddSubtractScreen(),
      binding: AddSubtractBinding(),
    ),GetPage(
      name: AppRoutes.compare,
      page: () => CompareScreen(),
      binding: CompareBinding(),
    ),GetPage(
      name: AppRoutes.missingNum,
      page: () => MissingNumbersScreen(),
      binding: MissingNumbersBindings(),
    ),GetPage(
      name: AppRoutes.time,
      page: () => TimeScreen(),
      binding: TimeBinding(),
    ),GetPage(
      name: AppRoutes.month,
      page: () => MonthsDaysScreens(),
      binding: MonthsDaysBinding(),
    ),GetPage(
      name: AppRoutes.quantity,
      page: () => QuantityScreen(),
      binding: QuantityBinding(),
    ),GetPage(
      name: AppRoutes.alphabets,
      page: () => AlphabetsScreen(),
      binding: AlphabetsBinding(),
    ),GetPage(
      name: AppRoutes.upper,
      page: () => UpperLowerScreen(),
      binding: UpperLowerBinding(),
    ),GetPage(
      name: AppRoutes.spelling,
      page: () => SpellingScreen(),
      binding: SpellingBindings(),
    ),
    GetPage(
      name: AppRoutes.proVersion,
      page: () => ProVersionScreen(),
      binding: ProVersionBinding(),
    ), GetPage(
      name: AppRoutes.videoSubcategory,
      page: () => VideoSubCategoryScreen(),
      binding:  VideoSubcategoryBinding() ,
    ),GetPage(
      name: AppRoutes.videoList,
      page: () => VideoListScreen(),
      binding:  VideoListBinding() ,
    ),GetPage(
      name: AppRoutes.videoPlayer,
      page: () => VideoPlayerScreen(),
      binding:  VideoPlayerBinding() ,
    ),
  ];
}
