import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  QRViewController? _qrViewController;

  String? _scannedData;

  // StreamController? _streamController;

  @override
  void initState() {
    super.initState();
    // _streamController = StreamController();
    // _streamController?.stream.listen((event) {
    //   print("Event data is $event");
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _qrViewController?.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (_qrViewController != null) {
      if (_qrViewController!.hasPermissions) {
        _qrViewController!.resumeCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        QRView(
          onPermissionSet: (controller, value) {},
          key: GlobalKey(debugLabel: 'QR'),
          onQRViewCreated: (QRViewController controller) {
            // if (_qrViewController != null) {
            _qrViewController = controller;
            // _streamController?.addStream(_qrViewController!.scannedDataStream);
            // _streamController?.stream.listen((event) {
            //   print("Event is $event");
            // });
            // }
            controller.scannedDataStream.listen((scanData) {
              if (scanData.code != null) {
                if (_scannedData == null) {
                  _scannedData = scanData.code;
                  Navigator.pop(context, _scannedData);
                }
              }
              // showDialog(
              //     context: context,
              //     builder: (BuildContext dialogContext) {
              //       return Dialog(
              //         child: Text("Scanned data is ${scanData.code}"),
              //       );
              //     });
            });
          },
        ),
      ],
    ));
  }
}
