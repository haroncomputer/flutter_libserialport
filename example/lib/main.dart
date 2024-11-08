import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  _ExampleAppState createState() => _ExampleAppState();
}

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

class _ExampleAppState extends State<ExampleApp> {
  List availablePorts = [];

  @override
  void initState() {
    super.initState();
    initPorts();
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
                Builder(
                  builder: (context) {
                    final port = SerialPort(address as String);
                    return ExpansionTile(
                      title: Text(address),
                      children: [
                        CardListTile('Description', port.description),
                        CardListTile('Transport', port.transport.toTransport()),
                        CardListTile('USB Bus', port.busNumber?.toPadded()),
                        CardListTile(
                            'USB Device', port.deviceNumber?.toPadded(),),
                        CardListTile('Vendor ID', port.vendorId?.toHex()),
                        CardListTile('Product ID', port.productId?.toHex()),
                        CardListTile('Manufacturer', port.manufacturer),
                        CardListTile('Product Name', port.productName),
                        CardListTile('Serial Number', port.serialNumber),
                        CardListTile('MAC Address', port.macAddress),
                      ],
                    );
                  },
                ),
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
  const CardListTile(this.name, this.value, {Key? key}) : super(key: key);
  final String name;
  final String? value;

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
