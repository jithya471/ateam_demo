import 'dart:convert';
import 'dart:math';
import 'package:ateam_demo/app/model/location_data.dart';
import 'package:ateam_demo/app/model/trip_model.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ateam_demo/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ResultController extends GetxController {
  MapboxMapController? mapController;
  final startLocation = Rxn<LocationData>();
  final endLocation = Rxn<LocationData>();
  final distance = RxDouble(0.0);
  final isMapInitialized = RxBool(false);
  final polylineCoordinates = RxList<LatLng>([]);
  final isLoading = RxBool(true);
  RxString isFrom = ''.obs;
 
  @override
  void onInit() {
    super.onInit();
    _getLocationsFromArguments();
    _calculateDistance();
  }

  void _getLocationsFromArguments() {
    try {
      final args = Get.arguments;

      if (args == null) {
        return;
      }

      startLocation.value = args['startLocation'] as LocationData;
      endLocation.value = args['endLocation'] as LocationData;
      isFrom.value = args['isFrom'] as String;
    } catch (e) {
      print('Error getting arguments: $e');
    }
  }

  void _calculateDistance() {
    if (startLocation.value != null && endLocation.value != null) {
      final distanceInMeters = Geolocator.distanceBetween(
        startLocation.value!.latitude,
        startLocation.value!.longitude,
        endLocation.value!.latitude,
        endLocation.value!.longitude,
      );
      distance.value = distanceInMeters / 1000;
    }
  }

  Future<void> onMapCreated(MapboxMapController controller) async {
    try {
      mapController = controller;

      if (startLocation.value != null && endLocation.value != null) {
        final midLat =
            (startLocation.value!.latitude + endLocation.value!.latitude) / 2;
        final midLng =
            (startLocation.value!.longitude + endLocation.value!.longitude) / 2;

        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(midLat, midLng),
              zoom: 10,
            ),
          ),
        );
      }

      await _initializeMap();
    } catch (e) {
      print('Error in onMapCreated: $e');
    }
  }

  Future<void> _initializeMap() async {
    try {
      if (mapController == null) {
        return;
      }

      await _addMarkers();
      await _drawPolyline();
      await _fitBounds();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to initialize map');
    }
  }

  Future<void> _addMarkers() async {
    if (startLocation.value == null ||
        endLocation.value == null ||
        mapController == null) return;

    try {
      await mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            startLocation.value!.latitude,
            startLocation.value!.longitude,
          ),
          iconImage: "marker-15",
          iconSize: 2.5,
          iconColor: "#FF0000",
          textField: startLocation.value!.name,
          textSize: 12.0,
          textOffset: const Offset(0, 2),
        ),
      );

      await mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(
            endLocation.value!.latitude,
            endLocation.value!.longitude,
          ),
          iconImage: "marker-15",
          iconSize: 2.5,
          iconColor: "#0000FF",
          textField: endLocation.value!.name,
          textSize: 12.0,
          textOffset: const Offset(0, 2),
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add markers');
    }
  }

  Future<void> _drawPolyline() async {
    if (startLocation.value == null ||
        endLocation.value == null ||
        mapController == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving/'
            '${startLocation.value!.longitude},${startLocation.value!.latitude};'
            '${endLocation.value!.longitude},${endLocation.value!.latitude}'
            '?geometries=geojson&access_token=$token'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;

          polylineCoordinates.value = coordinates
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();

          await mapController!.addLine(
            LineOptions(
              geometry: polylineCoordinates,
              lineColor: "#FF0000",
              lineWidth: 3.0,
              lineOpacity: 0.7,
            ),
          );
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch route');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to draw route');
    }
  }

  Future<void> _fitBounds() async {
    if (startLocation.value == null ||
        endLocation.value == null ||
        mapController == null) return;

    try {
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(startLocation.value!.latitude, endLocation.value!.latitude) - 0.1,
          min(startLocation.value!.longitude, endLocation.value!.longitude) -
              0.1,
        ),
        northeast: LatLng(
          max(startLocation.value!.latitude, endLocation.value!.latitude) + 0.1,
          max(startLocation.value!.longitude, endLocation.value!.longitude) +
              0.1,
        ),
      );

      await mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          left: 50,
          right: 50,
          top: 50,
          bottom: 50,
        ),
      );
    } catch (e) {
      print('Error fitting bounds: $e');
    }
  }

  Future<void> saveLocation() async {
    try {
      if (startLocation.value == null || endLocation.value == null) return;

      final trip = TripModel(
        startLocationName: startLocation.value!.name,
        startLatitude: startLocation.value!.latitude,
        startLongitude: startLocation.value!.longitude,
        endLocationName: endLocation.value!.name,
        endLatitude: endLocation.value!.latitude,
        endLongitude: endLocation.value!.longitude,
        distance: distance.value,
        savedAt: DateTime.now(),
      );

      final box = await Hive.openBox<TripModel>('trips');
      await box.add(trip);

      Get.snackbar(
        'Success',
        'Trip saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(AppRoutes.savedView);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save trip',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
