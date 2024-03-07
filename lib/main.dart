import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'mappage.dart';
import 'serial_port_page.dart';

void main() {
  print("starting thing");
  var ports = SerialPort.availablePorts;
  print(ports);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const SelectPort(),
    );
  }
}
