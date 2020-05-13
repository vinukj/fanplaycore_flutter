import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double latitude;
  double longitude;
  double newLongitude;
  double newLatitude;
  double lat1Radian;
  double lat2Radian;
  double lon1Radian;
  double lon2Radian;

  void getCurrentPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
//      final SharedPreferences prefs = await _prefs;
//      prefs.setDouble('homelatitude', latitude);
//      prefs.setDouble('homelongitude', longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getNewPosition() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      newLatitude = position.latitude;
      newLongitude = position.longitude;
      final SharedPreferences prefs = await _prefs;
      prefs.setDouble('newLatitude', newLatitude);
      prefs.setDouble('newLongitude', newLongitude);
    } catch (e) {
      print(e);
    }
  }

  void saveLatLong() async {}

  double distanceCalculator(lat1Radian, lon1Radian, lat2Radian, lon2Radian) {
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
