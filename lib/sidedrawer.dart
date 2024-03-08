import 'package:flutter/material.dart';

import 'serial_port_page.dart';



class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

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
