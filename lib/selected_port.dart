import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SelectedPort extends StatefulWidget {
  final SerialPort port;
  const SelectedPort({super.key, required this.port});

  @override
  State<SelectedPort> createState() => _SelectedPortState();
}

class _SelectedPortState extends State<SelectedPort> {
  late StreamSubscription<Uint8List> stream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(onPressed: () {
                stream.cancel();
                widget.port.close();
              Navigator.pop(context,widget.port );
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

  String getSerialData() {
    widget.port.openRead();
    //Uint8List read = widget.port.read(5, timeout: 5000);
    //widget.port.close();
    //return utf8.decode(read, allowMalformed: true);
    return "test";
    //print(read);
  }

  void init_stream() {
    setState(() {
      getSerialData();
      final reader = SerialPortReader(widget.port);
      stream = reader.stream.listen((data) {
        print('received: ${utf8.decode(data)}');
      });
    });
    /*
*/
    //setState(() => print("init"));
  }

  @override
  void initState() {
    super.initState();
    init_stream();
  }
}
