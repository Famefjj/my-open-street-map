import 'package:flutter/material.dart';
import 'package:my_open_street_map/models/cars_model.dart';

class DisplayContainer extends StatefulWidget {
  const DisplayContainer({
    super.key,
    required this.container,
    required this.id,
  });
  final Container container;
  final String id;

  @override
  State<DisplayContainer> createState() => _DisplayContainerState();
}

class _DisplayContainerState extends State<DisplayContainer> {
  var key = GlobalKey();
  Size? conSize;

  Size getContainerSize(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    return box.size;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      conSize = getContainerSize(key.currentContext!);
      CarsModel().textBoxModels[widget.id]!.width = conSize!.width;
      CarsModel().textBoxModels[widget.id]!.height = conSize!.height;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double markerHeight = CarsModel().markers[widget.id]!.height;
    // final double containerPadding = markerHeight*0.5+11;
    return (CarsModel().textBoxModels[widget.id]!.height == 0 ||
            CarsModel().textBoxModels[widget.id]!.width == 0)
        ? Opacity(
            opacity: 0,
            key: key,
            child: Container(
              padding: EdgeInsets.only(bottom: markerHeight * 0.5 + 11),
              child: widget.container,
            ),
          )
        : Container(
            key: key,
            padding: EdgeInsets.only(bottom: markerHeight * 0.5 + 11),
            child: widget.container,
          );
  }
}
