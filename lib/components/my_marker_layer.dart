import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:my_open_street_map/components/popup_with_arrow.dart';
import 'package:my_open_street_map/models/cars_model.dart';
import 'package:my_open_street_map/models/map_pos_notifier_model.dart';
import 'package:my_open_street_map/models/textbox_model.dart';

part '../models/my_marker.dart';

/// A [Marker] layer for [FlutterMap].
@immutable
class MyMarkerLayer extends StatelessWidget {
  /// The list of [MyMarker]s.
  final Map<String, MyMarker> markers;

  // final MyMarker? marker;

  /// Alignment of each marker relative to its normal center at [Marker.point]
  ///
  /// For example, [Alignment.topCenter] will mean the entire marker widget is
  /// located above the [Marker.point].
  ///
  /// The center of rotation (anchor) will be opposite this.
  ///
  /// Defaults to [Alignment.center]. Overriden by [Marker.alignment] if set.
  final Alignment alignment;

  /// Whether to counter rotate markers to the map's rotation, to keep a fixed
  /// orientation
  ///
  /// When `true`, markers will always appear upright and vertical from the
  /// user's perspective. Defaults to `false`. Overriden by [Marker.rotate].
  ///
  /// Note that this is not used to apply a custom rotation in degrees to the
  /// markers. Use a widget inside [Marker.child] to perform this.
  final bool rotate;

  /// Create a new [MyMarkerLayer] to use inside of [FlutterMap.children].
  MyMarkerLayer({
    super.key,
    required this.markers,
    this.alignment = Alignment.topCenter,
    this.rotate = false,
  });

  @override
  Widget build(BuildContext context) {
    final map = MapCamera.of(context);
    // final Map<String, TextboxModel> textBoxModels = CarsModel().textBoxModels;

    void hideAllTextBox() {
      for (var id in CarsModel().textBoxModels.keys) {
        CarsModel().textBoxModels[id]!.hideBox();
      }
    }

    Positioned mapMarkerElement(
        String id, Point pos, double right, double bottom) {
      final m = markers[id];
      final TextboxModel textBoxNotifier = CarsModel().textBoxModels[id]!;
      return Positioned(
        key: m!.key,
        left: pos.x - right,
        top: pos.y - bottom,
        child: (m.rotate ?? rotate)
            ? Transform.rotate(
                angle: -map.rotationRad,
                alignment: (m.alignment ?? alignment) * -1,
                child: GestureDetector(
                  onTap: textBoxNotifier.onClickMarker,
                  child: SizedBox(
                    width: m.width,
                    height: m.height,
                    child: m.child,
                  ),
                ),
              )
            : GestureDetector(
                onTap: textBoxNotifier.onClickMarker,
                child: SizedBox(
                  width: m.width,
                  height: m.height,
                  child: m.child,
                ),
              ),
      );
    }

    Iterable generatorTextBox(Map<String, MyMarker> markers) sync* {
      for (final id in CarsModel().textBoxModels.keys) {
        final MyMarker? m = markers[id];
        final TextboxModel textBoxModel = CarsModel().textBoxModels[id]!;

        final left = 0.5 * m!.width * ((m.alignment ?? alignment).x + 1);
        final top = 0.5 * m.height * ((m.alignment ?? alignment).y + 1);
        final double right = m.width - left;
        final double bottom = m.height - top;
        // final boxTop = -textBoxModel.height - 0.5 * m.height - 15;
        final boxTop = -textBoxModel.height;
        var boxLeft = -textBoxModel.width / 2;

        // Perform projection
        final pxPoint = map.project(m.point);

        // Cull if out of bounds
        if (!map.pixelBounds.containsPartialBounds(
          Bounds(
            Point(pxPoint.x + left, pxPoint.y - bottom),
            Point(pxPoint.x - right, pxPoint.y + top),
          ),
        )) continue;

        // Apply map camera to marker position
        final Point pos = pxPoint - map.pixelOrigin;
        final TextboxModel textBoxNotifier = CarsModel().textBoxModels[id]!;

        yield Positioned(
          left: pos.x.toDouble() + boxLeft,
          top: pos.y.toDouble() + boxTop,
          child: ListenableBuilder(
              listenable: textBoxNotifier,
              builder: (context, child) {
                return (textBoxNotifier.showBox)
                    ? Transform.rotate(
                        angle: -map.rotationRad,
                        alignment: (m.alignment ?? alignment) * -1,
                        child: PopupWithArrow(
                          id: id,
                          width: textBoxNotifier.width,
                          height: textBoxNotifier.height,
                          container: markers[id]!.container,
                        ),
                      )
                    : const SizedBox();
              }),
        );
      }
    }

    Iterable<Widget> generatorMarkers(Map<String, MyMarker> markers) sync* {
      for (final id in markers.keys) {
        final MyMarker? m = markers[id];
        // Resolve real alignment
        final left = 0.5 * m!.width * ((m.alignment ?? alignment).x + 1);
        final top = 0.5 * m.height * ((m.alignment ?? alignment).y + 1);
        final double right = m.width - left;
        final double bottom = m.height - top;

        // Perform projection
        final pxPoint = map.project(m.point);

        // Cull if out of bounds
        if (!map.pixelBounds.containsPartialBounds(
          Bounds(
            Point(pxPoint.x + left, pxPoint.y - bottom),
            Point(pxPoint.x - right, pxPoint.y + top),
          ),
        )) continue;

        // Apply map camera to marker position
        final Point pos = pxPoint - map.pixelOrigin;

        yield mapMarkerElement(id, pos, right, bottom);
      }
    }

    return MobileLayerTransformer(
      child: ListenableBuilder(
        listenable: MapPosNotifierModel(),
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: hideAllTextBox,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              ...generatorMarkers(markers),
              ...generatorTextBox(markers),
            ],
          );
        },
      ),
    );
  }
}
