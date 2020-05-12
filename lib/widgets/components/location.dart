import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:math_expressions/math_expressions.dart';

class Location {
  double latitude;
  double longitude;
  double lastLongitude;
  double lastLatitude;
  double lat1Radian;
  double lat2Radian;
  double lon1Radian;
  double lon2Radian;

  Future<void> getCurrentPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLastPosition() async {
    try {
      Position position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      lastLatitude = position.latitude;
      lastLongitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<double> distanceCalculator(
      lat1Radian, lon1Radian, lat2Radian, lon2Radian) async {
    double divider = 57.29577951;
    double milesToKilo = 1.609344;
    double formulaConst = 3963.0;
    double valLat1 = lat1Radian / divider;
    double vallon1 = lon1Radian / divider;
    double vallat2 = lat2Radian / divider;
    double vallon2 = lon2Radian / divider;
    double val1 = sin(valLat1);
    double val2 = sin(vallat2);
    double val3 = cos(valLat1);
    double val4 = cos(vallat2);
    double val5 = cos(vallon2 - vallon1);
    double distanceMoved =
        formulaConst * acos(val1 * val2 + val3 * val4 * val5);
    // print(distanceMoved);
    return distanceMoved;
  }
}
