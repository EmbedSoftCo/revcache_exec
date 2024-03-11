import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SelectedPort extends StatefulWidget {
  final SerialPort port;
  const SelectedPort({super.key, required this.port});

  @override
  State<SelectedPort> createState() => _SelectedPortState();
}

class _SelectedPortState extends State<SelectedPort> {
  @override
  void initState() {
    super.initState();
  }
  void initprint() {
    setState(() => print("init"));
  }

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
      body: Center(
      ),
    );
  }
}
