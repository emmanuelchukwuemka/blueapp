import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../config/theme.dart';

class QrScanner extends StatefulWidget {
  final Function(String) onCodeScanned;
  final VoidCallback onClose;

  const QrScanner({
    super.key,
    required this.onCodeScanned,
    required this.onClose,
  });

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? _barcode;
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Theme.of(context).platform == TargetPlatform.android) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppTheme.primaryBlue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_barcode != null)
                  Text('Scanned: ${_barcode!.code}')
                else
                  const Text('Scan a code'),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flash_on),
                      onPressed: () async {
                        await _controller?.toggleFlash();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_android),
                      onPressed: () async {
                        await _controller?.flipCamera();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _barcode = scanData;
      });
      if (scanData.code != null) {
        widget.onCodeScanned(scanData.code!);
      }
    });
  }
}