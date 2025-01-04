import 'dart:convert';
import 'package:ateam_demo/app/model/location_data.dart';
import 'package:ateam_demo/app/routes/app_routes.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeController extends GetxController {
  MapboxMapController? startMapController;
  MapboxMapController? endMapController;
  final Rxn<LocationData> startLocation = Rxn<LocationData>();
  final Rxn<LocationData> endLocation = Rxn<LocationData>();

  final startLocationController = TextEditingController();
  final endLocationController = TextEditingController();
  Symbol? startMarker;
  Symbol? endMarker;

  final double defaultZoom = 15.0;
  final double markerSize = 2.5;

  void onStartMapCreated(MapboxMapController controller) {
    startMapController = controller;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(20, 0),
          zoom: 1,
        ),
      ),
    );
  }

  void onEndMapCreated(MapboxMapController controller) {
    endMapController = controller;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(20, 0),
          zoom: 1,
        ),
      ),
    );
  }

  Future<void> addMarker(LatLng position, {required bool isStart}) async {
    try {
      final controller = isStart ? startMapController : endMapController;
      final existingMarker = isStart ? startMarker : endMarker;
      final searchText =
          isStart ? startLocationController.text : endLocationController.text;

      if (controller == null) return;

      if (existingMarker != null) {
        await controller.removeSymbol(existingMarker);
      }

      final marker = await controller.addSymbol(
        SymbolOptions(
          geometry: position,
          iconImage: "marker-15",
          iconSize: markerSize,
          iconColor: isStart ? "#FF0000" : "#0000FF",
          textField: searchText,
          textSize: 12.0,
          textOffset: const Offset(0, 2),
        ),
      );

      if (isStart) {
        startMarker = marker;
      } else {
        endMarker = marker;
      }

      final locationData = LocationData(
        name: searchText,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (isStart) {
        startLocation.value = locationData;
      } else {
        endLocation.value = locationData;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add marker',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> searchLocation({required bool isStart}) async {
    final searchText =
        isStart ? startLocationController.text : endLocationController.text;

    if (searchText.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a location',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$token'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'].isNotEmpty) {
          final coordinates = data['features'][0]['center'];
          final position = LatLng(coordinates[1], coordinates[0]);

          final controller = isStart ? startMapController : endMapController;
          if (controller != null) {
            await controller.animateCamera(
              CameraUpdate.newLatLngZoom(position, defaultZoom),
            );
            await addMarker(position, isStart: isStart);
          }
        } else {
          Get.snackbar(
            'Not Found',
            'Location not found',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Failed to load location data');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search location',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateToResult() {
    if (startLocation.value == null || endLocation.value == null) {
      Get.snackbar(
        'Missing Locations',
        'Please select both start and end locations',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.resultView,
      arguments: {
        'startLocation': startLocation.value,
        'endLocation': endLocation.value,
      },
    );
  }

  @override
  void onClose() {
    startLocationController.dispose();
    endLocationController.dispose();
    super.onClose();
  }
}
