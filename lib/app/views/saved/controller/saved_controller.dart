import 'dart:convert';
import 'dart:math';
import 'package:ateam_demo/app/model/trip_model.dart';
import 'package:ateam_demo/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class SavedViewController extends GetxController {
  final trips = <TripModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTrips();
  }

  Future<void> loadTrips() async {
    final box = await Hive.openBox<TripModel>('trips');
    trips.value = box.values.toList();
  }

  Future<List<LatLng>> _getRouteCoordinates(TripModel trip) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving/'
            '${trip.startLongitude},${trip.startLatitude};'
            '${trip.endLongitude},${trip.endLatitude}'
            '?geometries=geojson&access_token=$token'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;
          return coordinates
              .map((coord) => LatLng(coord[1] as double, coord[0] as double))
              .toList();
        }
      }
      return [
        LatLng(trip.startLatitude, trip.startLongitude),
        LatLng(trip.endLatitude, trip.endLongitude),
      ];
    } catch (e) {
      return [
        LatLng(trip.startLatitude, trip.startLongitude),
        LatLng(trip.endLatitude, trip.endLongitude),
      ];
    }
  }

  Future<void> onMapCreated(
      MapboxMapController mapController, TripModel trip) async {
    try {
      final routeCoordinates = await _getRouteCoordinates(trip);

      await mapController.addSymbol(
        SymbolOptions(
          geometry: LatLng(trip.startLatitude, trip.startLongitude),
          iconImage: "marker-15",
          iconSize: 2.5,
          iconColor: "#FF0000",
          textField: trip.startLocationName,
          textSize: 12.0,
          textOffset: const Offset(0, 2),
        ),
      );

      await mapController.addSymbol(
        SymbolOptions(
          geometry: LatLng(trip.endLatitude, trip.endLongitude),
          iconImage: "marker-15",
          iconSize: 2.5,
          iconColor: "#0000FF",
          textField: trip.endLocationName,
          textSize: 12.0,
          textOffset: const Offset(0, 2),
        ),
      );

      await mapController.addLine(
        LineOptions(
          geometry: routeCoordinates,
          lineColor: "#FF0000",
          lineWidth: 3.0,
          lineOpacity: 0.7,
        ),
      );

      double minLat = double.infinity;
      double maxLat = -double.infinity;
      double minLng = double.infinity;
      double maxLng = -double.infinity;

      for (var point in routeCoordinates) {
        minLat = min(minLat, point.latitude);
        maxLat = max(maxLat, point.latitude);
        minLng = min(minLng, point.longitude);
        maxLng = max(maxLng, point.longitude);
      }

      const padding = 0.1;
      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat - padding, minLng - padding),
            northeast: LatLng(maxLat + padding, maxLng + padding),
          ),
          left: 25,
          right: 25,
          top: 25,
          bottom: 25,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to set up map: $e');
    }
  }
}
