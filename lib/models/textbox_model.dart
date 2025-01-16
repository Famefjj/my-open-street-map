import 'package:flutter/widgets.dart';

class TextboxModel with ChangeNotifier {
  TextboxModel();
  bool showBox = false;
  double width = 0;
  double height = 0;

  void onClickMarker() {
    showBox = true;
    notifyListeners();
  }

  void hideBox() {
    showBox = false;
    notifyListeners();
  }
}
