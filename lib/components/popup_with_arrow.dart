import 'package:flutter/material.dart';
import 'package:my_open_street_map/components/display_container.dart';
import 'package:my_open_street_map/models/cars_model.dart';

class PopupWithArrow extends StatefulWidget {
  PopupWithArrow({
    super.key,
    required this.id,
    required this.width,
    required this.height,
    required this.container,
  });

  final String id;
  final double width;
  final double height;
  Container? container;
  @override
  State<PopupWithArrow> createState() => _PopupWithArrowState();
}

class _PopupWithArrowState extends State<PopupWithArrow> {
  Widget displayContainerWithArrow() {
    final double markerHeight = CarsModel().markers[widget.id]!.height;
    final double containerHeight = CarsModel().textBoxModels[widget.id]!.height;
    // final double
    return Stack(
      children: <Widget>[
        DisplayContainer(container: widget.container!, id: widget.id),
        Positioned(
          left: CarsModel().textBoxModels[widget.id]!.width * 0.5,
          top: containerHeight - markerHeight * 0.5 - 12,
          child: CustomPaint(
            size: const Size(10, 11),
            painter: TrianglePainter(
              strokeColor: const Color.fromARGB(240, 255, 255, 255),
              // strokeColor: Colors.red,
              paintingStyle: PaintingStyle.fill,
              strokeWidth: 10,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.container != null ? displayContainerWithArrow() : Container();
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x * 0.5, 0)
      ..lineTo(-x * 0.5, 0)
      ..lineTo(0, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
