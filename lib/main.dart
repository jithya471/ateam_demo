import 'package:ateam_demo/app/model/trip_model.dart';
import 'package:ateam_demo/app/routes/app_pages.dart';
import 'package:ateam_demo/app/routes/app_routes.dart';
import 'package:ateam_demo/app/views/home/bindings/home_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TripModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homeView,
      getPages: AppPages.pages,
      initialBinding: HomeBindings(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
