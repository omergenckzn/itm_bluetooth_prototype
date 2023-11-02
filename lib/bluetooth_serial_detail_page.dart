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





  void _onDataReceived(Uint8List data) {

    print(data);
    if(data != null && data.length > 0) {
      chunks.add(data);
      contentLenght += data.length;
    }
    
    print('Data Lenght: ${data.length}, chunks: ${chunks.length}');
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
