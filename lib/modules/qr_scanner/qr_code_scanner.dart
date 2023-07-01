import 'package:box_cricket/base_widgets/base_hero_widget.dart';
import 'package:box_cricket/constants/color_constants.dart';
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

  late bool _flashOn;

  // StreamController? _streamController;

  @override
  void initState() {
    super.initState();
    _flashOn = false;
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
      appBar: AppBar(title: const Text("Scan QR")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: QRView(
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
          ),
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseHeroWidget(
                    tag: "qr_scan",
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: 250,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  StatefulBuilder(builder: (context, sst) {
                    return InkWell(
                        onTap: () async {
                          try {
                            await _qrViewController?.toggleFlash();
                            if (_flashOn) {
                              _flashOn = false;
                            } else {
                              _flashOn = true;
                            }
                          } catch (e) {
                            print("Error in flash ${e.toString()}");
                          }
                          sst(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (_flashOn ? Colors.white : Colors.black)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black)),
                          child: Icon(
                            _flashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                          ),
                        ));
                  }),
                ],
              ))
        ],
      ),
    );
  }
}
