import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

String inputbuff = "";

class SelectedPort extends StatefulWidget {
  final SerialPort port;
  const SelectedPort({super.key, required this.port});

  @override
  State<SelectedPort> createState() => _SelectedPortState();
}

class _SelectedPortState extends State<SelectedPort> {
  final Logger logger = Logger("SelectedPort");
  late StreamSubscription<Uint8List> stream;
  late StringBuffer strbuff;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          stream.cancel();
          widget.port.close();
          logger.fine("strbuff");
          logger.fine(strbuff.toString());
          Navigator.pop(context, widget.port);
        }),
        title: Text(
          widget.port.name ?? "",
          textScaler: const TextScaler.linear(2.0),
        ),
        centerTitle: true,
      ),
      //body: StreamBuilder(stream: stream, builder: builder),
      body: const Text("AD"),
    );
  }

  @override
  void initState() {
    super.initState();
    initStream();
  }

  void initStream() {
    setState(() {
      // open the port to read
      widget.port.openRead();
      final reader = SerialPortReader(widget.port);
      strbuff = StringBuffer();
      // if data is available in the buffer call the anonymous function in the listen()
      stream = reader.stream.listen((data) {
        // store all incoming serial data
        strbuff.write(utf8.decode(data));
      });
    });
  }
}
