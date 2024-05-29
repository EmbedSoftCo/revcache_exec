import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:mcu_gps_parser/McuData.dart';
import 'package:mcu_gps_parser/mcu_gps_parser.dart';

class MapPage extends StatefulWidget {
  final String title;
  final String data;

  const MapPage({super.key, required this.title, required this.data});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// instantiate logger for this page
  final Logger logger = Logger("mappage");
  //create list of objects containing a coord and temp
  late List<McuData> mcuDatalisting;
  //create list of objects with x and y coords
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

            /// create a Line through all point in the coordlist to show the route
            PolylineLayer(
              polylines: [
                Polyline(
                  points: coordlist,
                  color: Colors.pink,
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => logger
                      .finer(Uri.parse('https://openstreetmap.org/copyright')),
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
      try {
        ///convert passed in data to json
        final List t = json.decode(widget.data);

        ///turn Json data into list of objects
        mcuDatalisting = t.map((item) => McuData.fromJson(item)).toList();

        /// extract x and y coords from list of objects
        coordlist = mcuDatalisting.toLatLngList();

        ///print the list of coords
        logger.fine(coordlist);
      } catch (e) {
        /// if an error occurs print it
        logger.severe(e);
      }
    });
  }
}
