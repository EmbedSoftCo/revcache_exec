import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'serial_port_page.dart';
import 'mappage.dart';



class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            child: Text('Header'),
          ),
          ListTile(
            title: const Text('R1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectPort()),
              );
            },
          ),
        ],
      ),
    );
  }
}
