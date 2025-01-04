import 'package:ateam_demo/app/global/buttons.dart';
import 'package:ateam_demo/app/utils/colors.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:ateam_demo/app/utils/styles.dart';
import 'package:ateam_demo/app/views/result/controller/result_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ResultView extends StatelessWidget {
  final controller = Get.put(ResultController());

  ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.startLocation.value == null ||
            controller.endLocation.value == null) {
          return const Center(
            child: Text('Location data not available'),
          );
        }

        return Stack(
          children: [
            Column(
              children: [
                _buildHeaderSection(),
                _buildMapSection(),
                _buildBottomButtons(),
              ],
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildMapSection() {
    return Expanded(
      child: MapboxMap(
        accessToken: token,
        styleString: 'mapbox://styles/mapbox/streets-v11',
        initialCameraPosition: CameraPosition(
          target: LatLng(
            controller.startLocation.value?.latitude ?? 0,
            controller.startLocation.value?.longitude ?? 0,
          ),
          zoom: 12,
        ),
        onMapCreated: controller.onMapCreated,
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Obx(() => Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Appcolors.primaryColor,
            boxShadow: [
              BoxShadow(
                color: Appcolors.lightGrey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: verticalPadding * 2,
                horizontal: horizontalPadding * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),
                  Text(
                    'YOUR LOCATION',
                    style: style(
                        12,
                        FontWeight.w400,
                        Appcolors.whitecolor.withOpacity(.8),
                        null,
                        null,
                        null,
                        FontStyle.italic),
                  ),
                  Text(
                    controller.startLocation.value?.name.capitalizeFirst ?? '',
                    style: style(18, FontWeight.w500, Appcolors.whitecolor),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Appcolors.whitecolor.withOpacity(.8),
                        size: 18,
                      ),
                      Text(
                        '${controller.startLocation.value?.latitude.toStringAsFixed(6)}, ${controller.startLocation.value?.longitude.toStringAsFixed(6)}',
                        style: style(12, FontWeight.w400,
                            Appcolors.whitecolor.withOpacity(.8), 2),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                    child: Divider(
                      color: Appcolors.whitecolor,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    controller.endLocation.value?.name.capitalizeFirst ?? '',
                    style: style(18, FontWeight.w500, Appcolors.whitecolor),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Appcolors.whitecolor.withOpacity(.8),
                        size: 18,
                      ),
                      Text(
                        '${controller.endLocation.value?.latitude.toStringAsFixed(6)}, ${controller.endLocation.value?.longitude.toStringAsFixed(6)}',
                        style: style(12, FontWeight.w400,
                            Appcolors.whitecolor.withOpacity(.8), 2),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.near_me_outlined,
                        color: Appcolors.whitecolor.withOpacity(.8),
                        size: 18,
                      ),
                      Text(
                        '${controller.distance.value.toStringAsFixed(1)} km',
                        style: style(12, FontWeight.w400,
                            Appcolors.whitecolor.withOpacity(.8), 2),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.05),
                ],
              ),
            ),
          ),
        ));
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
                  onTap: controller.isFrom.value == 'saved'
                      ? Get.back
                      : controller.saveLocation,
                  child: SizedBox(
                    width: Get.width * 0.3,
                    child: Button(
                        text: controller.isFrom.value == 'saved'
                            ? 'Go Back'
                            : 'Save'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
