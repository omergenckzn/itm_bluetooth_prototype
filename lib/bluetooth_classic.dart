import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:itm_bluetooth_prototype/bluetooth_device_list_entry.dart';
import 'package:itm_bluetooth_prototype/bluetooth_serial_detail_page.dart';

class BluetoothClassic extends StatefulWidget {
  const BluetoothClassic({super.key});

  @override
  State<BluetoothClassic> createState() => _BluetoothClassicState();
}

class _BluetoothClassicState extends State<BluetoothClassic>
    with WidgetsBindingObserver {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getBTState();
    _stateChangeListener();
    _listBondedDevices();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      ///resume
    }
    if (_bluetoothState.isEnabled) {
      _listBondedDevices();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      if (_bluetoothState.isEnabled) {
        _listBondedDevices();
      } else {
        devices.clear();
      }
      print("State isEnabled: ${state.isEnabled}");
      setState(() {});
    });
  }

  _listBondedDevices() {
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices;
      });
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
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              }

              future().then((_) {
                setState(() {});
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
          ),
          Expanded(
              child: ListView(
                  children: devices.map(
            (_device) {
              return BluetoothDeviceListEntry(
                  device: _device,
                  rssi: 0,
                  enabled: true,
                  onTap: () {
                    print('item');
                    _goToDetailPage(_device);
                  },
                  onLongPress: () {});
            },
          ).toList())),
        ],
      ),
    );
  }

  void _goToDetailPage(BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BluetoothSerialDetailPage(server: server)));
  }
}
