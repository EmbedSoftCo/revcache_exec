import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'sidedrawer.dart';

class MapPage extends StatefulWidget {
  final String title;

  const MapPage({super.key, required this.title});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: const SideDrawer(),
        body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(52.03492, 5.57092),
            initialZoom: 9.2,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'eu.vdwege.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: const [
                    LatLng(52.03492, 5.57092),
                    LatLng(52.0347732, 5.570698),
                    LatLng(52.0335682, 5.570569),
                    LatLng(52.033440, 5.570901),
                    LatLng(52.034595, 5.571805),
                    LatLng(52.0347732, 5.570698),
                  ],
                  color: Colors.pink,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate back to first route when tapped.
              },
              child: const Text('Go back!'),
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () =>
                      print(Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ));
  }

  void onPressed() {
    print("wtf");
  }
}
