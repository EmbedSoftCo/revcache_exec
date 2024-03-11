import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'serial_port_page.dart';
import 'mappage.dart';

void main() {
  var sp_conf = SerialPortConfig();
  sp_conf.baudRate = 115200;
  sp_conf.bits = 8;

  var port = SerialPort.availablePorts;
  print(port);
  if (port.isNotEmpty) {
    var p = SerialPort(port[0]);
    p.openReadWrite();
   Uint8List bytes = utf8.encode('H'); 
    p.write(bytes ,timeout: 5000);
    var read = p.read(bytes.length, timeout: 5000);
    print(read);
    p.close();
  }
  
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
      home: const MapPage(title: 'Flutter Serial Port example'),
      //home: const SelectPort(),
    );
  }
}
