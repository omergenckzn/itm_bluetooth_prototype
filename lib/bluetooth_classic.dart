import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothClassic extends StatefulWidget {
  const BluetoothClassic({super.key});

  @override
  State<BluetoothClassic> createState() => _BluetoothClassicState();
}

class _BluetoothClassicState extends State<BluetoothClassic> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  @override
  void initState() {
    super.initState();
    _getBTState();
    _stateChangeListener();
  }

  _getBTState() {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {});
    });
  }

  _stateChangeListener() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      print("State isEnabled: ${state.isEnabled}");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth setting"),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              future() async {
                if(value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              }

              future().then((_)  {
                setState(() {

                });
              });
            },
          ),
          ListTile(
            title: Text('Bluetooth Status'),
            subtitle: Text(_bluetoothState.toString()),
            trailing: ElevatedButton(
              onPressed: () {
                FlutterBluetoothSerial.instance.openSettings();
              },
              child: Text('Settings'),
            ),
          )
        ],
      ),
    );
  }
}
