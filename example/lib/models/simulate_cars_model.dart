import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:my_open_street_map/my_open_street_map.dart';

class SimulateCarsModel {
  SimulateCarsModel();

  Map<String, LatLng> carPosMap = {};
  Map<String, MyMarker> markers = {};

  // final LatLng ref1 = LatLng(13.740491667143678, 100.52843224260232);
  // final LatLng ref2 = LatLng(13.744401, 100.814510);
  // final LatLng ref3 = LatLng(13.628823, 100.822143);
  // final LatLng ref4 = LatLng(13.632634, 100.529341);

  void generateRandomLatLng(String id) {
    final double randomLat = Random().nextDouble() * 0.12 + 13.62;
    final double randomLong = Random().nextDouble() * 0.294 + 100.528;

    carPosMap[id] = LatLng(randomLat, randomLong);
  }

  void moveCar(String id) {
    final newCarLat = carPosMap[id]!.latitude + 0.001;
    final newCarLng = carPosMap[id]!.longitude;

    carPosMap[id] = LatLng(newCarLat, newCarLng);
  }

//   void moveMultipleCars() {
//     for (var i = 0; i < carPosMap.length; i++) {
//       moveCar(i.toString());
//     }
//   }
}
