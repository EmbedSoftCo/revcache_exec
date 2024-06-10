import 'package:app/selected_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'custom/cardlisttile.dart';

extension IntToString on int {
  // helper functions added onto the int type

  /// convert int to hex string
  String toHex() => '0x${toRadixString(16)}';

  /// convert int to a padded string, default 3 digits
  String toPadded([int width = 3]) => toString().padLeft(width, '0');

  /// convert int to SerialPortTransport type name string, returns Unknown if invalid
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class SelectPort extends StatefulWidget {
  const SelectPort({super.key});

  @override
  State<SelectPort> createState() => _SelectPortState();
}

class _SelectPortState extends State<SelectPort> {
  var availablePorts = [];

  ///Called when the widget is initialized
  @override
  void initState() {
    super.initState();
    initPorts();
  }

  /// Create a new page for the selected serialport
  /// when the opened page is closed, the serialport is closed
  void openSerialPortPage(SerialPort selectport) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectedPort(port: selectport)),
    ).then((data) {
      // executes on pop
      if (data is SerialPort) {
        data.close();
      }
    });
  }

  ///setup internal data.
  ///using setState to redraw the UI and a arrow function to execute to get the data
  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  /// Build the UI for this page
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),

        /// Build the body of the page this forms a Tree with the Scrollbar as the root
        body: Scrollbar(
          child: ListView(
            children: [
              for (final address in availablePorts)
                Builder(builder: (context) {
                  final port = SerialPort(address);
                  return ExpansionTile(
                    title: Text(address),
                    children: [
                      TextButton(
                          child: const Text("Connect"),
                          onPressed: () => openSerialPortPage(port)),
                      CardListTile('Description', port.description),
                      CardListTile('Transport', port.transport.toTransport()),
                      CardListTile('USB Bus', port.busNumber?.toPadded()),
                      CardListTile('USB Device', port.deviceNumber?.toPadded()),
                      CardListTile('Vendor ID', port.vendorId?.toHex()),
                      CardListTile('Product ID', port.productId?.toHex()),
                      CardListTile('Manufacturer', port.manufacturer),
                      CardListTile('Product Name', port.productName),
                      CardListTile('Serial Number', port.serialNumber),
                      CardListTile('MAC Address', port.macAddress),
                    ],
                  );
                }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPorts,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
