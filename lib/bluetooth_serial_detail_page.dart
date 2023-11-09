import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothSerialDetailPage extends StatefulWidget {
  const BluetoothSerialDetailPage({super.key, required this.server});

  final BluetoothDevice server;

  @override
  State<BluetoothSerialDetailPage> createState() =>
      _BluetoothSerialDetailPageState();
}

class _BluetoothSerialDetailPageState extends State<BluetoothSerialDetailPage> {
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;
  bool isDisconnecting = false;

  List<List<int>> chunks = [];
  int contentLenght = 0;
  Uint8List? _bytes;

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    _getBTConnection();
    super.initState();
  }

  _getBTConnection() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      setState(() {});
      connection?.input?.listen((_onDataReceived), onDone: () {
        if (isDisconnecting) {
          print('Disconnecting locally');
        } else {
          print('Disconnecting remotely');
        }
        if (this.mounted) {
          setState(() {});
          Navigator.of(context).pop();
        }
      });
    }).catchError((error) {
      Navigator.of(context).pop();
    });
  }





  List<int> accumulatedData = [];

  void _onDataReceived(Uint8List data) {
    // Append the received data to the accumulatedData list
    accumulatedData.addAll(data);

    // Check if there's a newline character to indicate a complete message
    int newlineIndex = accumulatedData.indexOf(10); // 10 is the ASCII code for '\n'

    if (newlineIndex >= 0) {
      // Extract the complete message
      Uint8List completeMessage = Uint8List.fromList(accumulatedData.sublist(0, newlineIndex + 1));

      // Process the complete message
      String message = String.fromCharCodes(completeMessage).replaceAll("_", "");
      print(message);

      // Remove the processed message from accumulatedData
      accumulatedData.removeRange(0, newlineIndex + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: (isConnecting
              ? Text('connecting to ${widget.server.name} ... ')
              : isConnected
                  ? Text('Connected with ${widget.server.name}')
                  : Text('Disconnected'))),

      body: SafeArea(
        child: isConnected ? Column(
          children: [
            
          ],
        ) : Text('Connecting ... ', style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),),
      ),
    );
  }
}
