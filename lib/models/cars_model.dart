import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_open_street_map/components/my_marker_layer.dart';
import 'package:my_open_street_map/models/textbox_model.dart';

class CarsModel extends ChangeNotifier {
  static final CarsModel _singleton = CarsModel._internal();

  CarsModel._internal();
  factory CarsModel() {
    return _singleton;
  }

  Map<String, LatLng> carPosMap = {};
  Map<String, MyMarker> markers = {};
  Map<String, TextboxModel> textBoxModels = {};

  void resetCarsMap() {
    CarsModel().carPosMap = {};
    markers = {};
    textBoxModels = {};
  }

  void setCarLatLng(String id, LatLng latLng) {
    carPosMap[id] = latLng;
  }
}
