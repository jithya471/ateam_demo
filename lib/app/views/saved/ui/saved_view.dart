import 'package:ateam_demo/app/global/buttons.dart';
import 'package:ateam_demo/app/global/header.dart';
import 'package:ateam_demo/app/model/location_data.dart';
import 'package:ateam_demo/app/routes/app_routes.dart';
import 'package:ateam_demo/app/utils/colors.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:ateam_demo/app/utils/styles.dart';
import 'package:ateam_demo/app/views/saved/controller/saved_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  final controller = Get.put(SavedViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Obx(() => controller.trips.isEmpty
                  ? Center(
                      child: Text(
                        'No saved trips',
                        style: style(16, FontWeight.w500, Appcolors.textColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.trips.length,
                      itemBuilder: (context, index) {
                        final trip = controller.trips[index];
                        final startLocationName = trip.startLocationName;
                        final endLocationName = trip.endLocationName;
                        final startLatitude = trip.startLatitude;
                        final startLongitude = trip.startLongitude;
                        final endLatitude = trip.endLatitude;
                        final endLongitude = trip.endLongitude;

                        final locationData = LocationData(
                          name: startLocationName,
                          latitude: startLatitude,
                          longitude: startLongitude,
                        );

                        final endLocation = LocationData(
                          name: endLocationName,
                          latitude: endLatitude,
                          longitude: endLongitude,
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: verticalPadding),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.resultView,
                                arguments: {
                                  'startLocation': locationData,
                                  'endLocation': endLocation,
                                  'isFrom': 'saved'
                                },
                              );
                            },
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Appcolors.whitecolor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Appcolors.lightGrey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                    offset: const Offset(3, 4),
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(horizontalPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Appcolors.lightGrey,
                                              ),
                                            ),
                                            Text(
                                              'Trip - ${index + 1}',
                                              style: style(16, FontWeight.w500,
                                                  Appcolors.textColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: verticalPadding),
                                    SizedBox(
                                      height: 130,
                                      child: MapboxMap(
                                        accessToken: token,
                                        styleString:
                                            'mapbox://styles/mapbox/streets-v11',
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            (trip.startLatitude +
                                                    trip.endLatitude) /
                                                2,
                                            (trip.startLongitude +
                                                    trip.endLongitude) /
                                                2,
                                          ),
                                          zoom: 10,
                                        ),
                                        onMapCreated: (mapController) =>
                                            controller.onMapCreated(
                                                mapController, trip),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
            ),
          ),
          _buildBottomButtons(),
        ],
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
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: Get.width * 0.3,
                    child: const Button(text: 'Go Back'),
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
