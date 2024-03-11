import 'package:app/selected_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
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

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  void openSerialPortPage(SerialPort selectport) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectedPort(port: selectport)),
    ).then((data) {
      // executes on pop
      print(data);
      if (data is SerialPort) {
        print("data is SerialPort");
        data.close();
      } else {
        print("data is not SerialPort");
        print(data.runtimeType);
      }
    });
  }

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),
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

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  const CardListTile(this.name, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}
