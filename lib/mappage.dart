import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:mcu_gps_parser/McuData.dart';
import 'package:mcu_gps_parser/mcu_gps_parser.dart';
import 'sidedrawer.dart';

class MapPage extends StatefulWidget {
  final String title;
  final String data;

  const MapPage({super.key, required this.title, required this.data});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Logger logger = Logger("mappage");
  late List<McuData> McuDatalisting;
  late List<LatLng> coordlist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
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
                  points: coordlist,
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
                      logger.finer(Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    createState();
  }

  void createState() {
    setState(() {
      final List t = json.decode(widget.data);
      McuDatalisting = t.map((item) => McuData.fromJson(item)).toList();
      coordlist = McuDatalisting.toLatLngList();
      logger.fine(coordlist);
    });
  }
}
