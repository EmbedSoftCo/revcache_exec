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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Port'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(widget.port.name??"",
textScaler: TextScaler.linear(3.0),
        ),
      ),    
    );
  }
}
