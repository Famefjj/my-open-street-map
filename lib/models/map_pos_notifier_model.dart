import 'package:flutter/material.dart';
import 'package:my_open_street_map/components/my_marker_layer.dart';
import 'package:my_open_street_map/models/cars_model.dart';
import 'package:my_open_street_map/models/textbox_model.dart';

class MapPosNotifierModel extends ChangeNotifier {
  // MapPosNotifierModel({this.id, this.marker});

  static final MapPosNotifierModel _singleton = MapPosNotifierModel._internal();

  MapPosNotifierModel._internal();
  Map<String, MyMarker> markers = {};

  void editMarkerById(String id, MyMarker marker) {
    CarsModel().markers[id] = marker;
    CarsModel().textBoxModels[id] ??= TextboxModel();
    markers[id] = marker;
    notifyListeners();
  }

  factory MapPosNotifierModel() {
    return _singleton;
  }
}
