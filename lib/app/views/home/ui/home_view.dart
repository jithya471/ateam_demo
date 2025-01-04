import 'package:ateam_demo/app/global/buttons.dart';
import 'package:ateam_demo/app/global/header.dart';
import 'package:ateam_demo/app/global/textfields.dart';
import 'package:ateam_demo/app/routes/app_routes.dart';
import 'package:ateam_demo/app/utils/colors.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:ateam_demo/app/views/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Appcolors.whitecolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Header(),
          SizedBox(height: Get.height * 0.04),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  _buildLocationContainer(
                    controller: controller.startLocationController,
                    onMapCreated: controller.onStartMapCreated,
                    onSearch: () => controller.searchLocation(isStart: true),
                    hintText: 'Start location',
                    iconColor: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationContainer(
                    controller: controller.endLocationController,
                    onMapCreated: controller.onEndMapCreated,
                    onSearch: () => controller.searchLocation(isStart: false),
                    hintText: 'End location',
                    iconColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildLocationContainer({
    required TextEditingController controller,
    required Function(MapboxMapController) onMapCreated,
    required VoidCallback onSearch,
    required String hintText,
    required Color iconColor,
  }) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Appcolors.whitecolor,
        boxShadow: [
          BoxShadow(
            color: Appcolors.lightGrey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(horizontalPadding),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: iconColor,
                  ),
                ),
                Expanded(
                  child: TextFields(
                    hintText: hintText,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                IconButton(
                  onPressed: onSearch,
                  icon: const Icon(Icons.search),
                  color: Appcolors.lightGrey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 130,
              child: MapboxMap(
                accessToken: token,
                styleString: 'mapbox://styles/mapbox/streets-v11',
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
                onMapCreated: onMapCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      width: Get.width,
      color: Appcolors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: verticalPadding * 2,
          horizontal: horizontalPadding * 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: GestureDetector(
                    onTap: () {
                      controller.navigateToResult();
                    },
                    child: const Button(text: 'Navigate')),
              ),
            ),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.savedView);
                    },
                    child: const Button(text: 'Saved')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
