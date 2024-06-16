import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:app/parser.dart';

class MapPage extends StatefulWidget {
  final String title;
  final Parser data;

  const MapPage({super.key, required this.title, required this.data});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// instantiate logger for this page
  final Logger logger = Logger("mappage");
  //create list of objects containing a coord and temp
  //create list of objects with x and y coords
  late List<LatLng> coordlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: coordlist.elementAt(0),
            initialZoom: 20.0,
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
      coordlist = widget.data.gpscoords();
    });
    for (var coord in coordlist) {
      print(coord);
    }
  }
}
