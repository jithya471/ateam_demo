import 'package:ateam_demo/app/routes/app_routes.dart';
import 'package:ateam_demo/app/views/home/bindings/home_bindings.dart';
import 'package:ateam_demo/app/views/home/ui/home_view.dart';
import 'package:ateam_demo/app/views/result/ui/result_view.dart';
import 'package:ateam_demo/app/views/saved/ui/saved_view.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.homeView,
      page: () => const HomeView(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: AppRoutes.resultView,
      page: () => ResultView(),
    ),
    GetPage(
      name: AppRoutes.savedView,
      page: () => const SavedView(),
    )
  ];
}
