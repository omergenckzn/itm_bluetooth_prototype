// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class BleScanner extends StatefulWidget {
//   @override
//   _BleScannerState createState() => _BleScannerState();
// }
//
// class _BleScannerState extends State<BleScanner> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<BluetoothDevice> devices = [];
//
//   @override
//   void initState() {
//     super.initState();
//     startScanning();
//   }
//
//   void startScanning() async {
//     await flutterBlue.startScan();
//     flutterBlue.scanResults.listen((results) {
//       for (ScanResult result in results) {
//         if (!devices.contains(result.device)) {
//           setState(() {
//             devices.add(result.device);
//           });
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLE Scanner'),
//       ),
//       body: ListView.builder(
//         itemCount: devices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(devices[index].name),
//             subtitle: Text(devices[index].id.toString()),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     flutterBlue.stopScan();
//     super.dispose();
//   }
// }