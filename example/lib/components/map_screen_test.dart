import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_open_street_map/my_open_street_map.dart';
import '../models/simulate_cars_model.dart';

//==== you must import this yourself additional to my_open_street_map =====//
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_open_street_map/models/map_pos_notifier_model.dart';
//=========================================================================//

class MapScreenTest extends StatelessWidget {
  MapScreenTest({super.key});

  final Widget mapPin = SvgPicture.asset(
    'map-marker.svg',
    semanticsLabel: 'Dart Logo',
  );
  final SimulateCarsModel simulateCars = SimulateCarsModel();

  void updateCarMarker(String id, LatLng carLatLng) {
    final MyMarker marker = MyMarker(
      id: id,
      point: carLatLng,
      width: 50,
      height: 50,
      child: mapPin,
      container: (double.tryParse(id)! % 2 == 0)
          ? myCustomContainer1()
          : myCustomContainer2(),
    );

    // this function will edit marker of target car's id to a new marker value.
    // and also automatically notify listeners.
    MapPosNotifierModel().editMarkerById(id, marker);
  }

  void simulatedMoveCar(String id) {
    final double newCarLat = simulateCars.carPosMap[id]!.latitude + 0.001;
    final double newCarLng = simulateCars.carPosMap[id]!.longitude;
    final LatLng newLatLng = LatLng(newCarLat, newCarLng);

    updateCarMarker(id, newLatLng);
  }

  void simulatedCarsTest() {
    for (var i = 0; i < 500; i++) {
      String id = i.toString();
      simulateCars.generateRandomLatLng(id);

      // update car marker by id
      updateCarMarker(id, simulateCars.carPosMap[id]!);
    }

    // set timer to move car in periodic order repeatly.
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      int id = timer.tick % simulateCars.carPosMap.length;
      simulatedMoveCar(id.toString());
    });
  }

  Container myCustomContainer1() {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          "Hello",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Container myCustomContainer2() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          "Hello",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    simulatedCarsTest();
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(13.738874123764363, 100.52841708740675),
      ),
      children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // tileProvider: NetworkTileProvider(),
          tileProvider: CancellableNetworkTileProvider(),

          // And many more recommended properties!
        ),
        MyMarkerLayer(
          alignment: Alignment.topCenter,
          rotate: true,
          markers: MapPosNotifierModel().markers,
        ),
        RichAttributionWidget(
          // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse(
                  'https://openstreetmap.org/copyright')), // (external)
            ),
            // Also add images...
          ],
        ),
      ],
    );
  }
}
