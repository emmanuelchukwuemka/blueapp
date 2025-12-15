import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/points_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/custom_button.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isScanning = false;

  @override
  void dispose() {
    _pointsController.dispose();
    _codeController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (_controller != null) {
      _controller!.pauseCamera();
      _controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (_isScanning && scanData.code != null) {
        setState(() {
          _codeController.text = scanData.code!;
          _isScanning = false;
        });
        controller.pauseCamera();
      }
    });
  }

  void _toggleScanner() {
    setState(() {
      _isScanning = !_isScanning;
      if (!_isScanning) {
        _controller?.pauseCamera();
      } else {
        _controller?.resumeCamera();
      }
    });
  }

  Future<void> _redeemPoints() async {
    final pointsText = _pointsController.text;
    if (pointsText.isEmpty) return;

    final points = int.tryParse(pointsText);
    if (points == null) {
      _showError('Please enter a valid number');
      return;
    }

    final pointsProvider = Provider.of<PointsProvider>(context, listen: false);
    
    if (points < AppConstants.minRedemptionPoints) {
      _showError('Minimum redemption is ${AppConstants.minRedemptionPoints} points');
      return;
    }

    if (points > pointsProvider.totalPoints) {
      _showError('Insufficient balance');
      return;
    }

    // Show Confirmation Dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to redeem $points points.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppConstants.bankDetailsMessage,
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processRedemption(points);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _processRedemption(int points) async {
    final success = await Provider.of<PointsProvider>(context, listen: false).requestRedemption(points);
    
    if (mounted) {
      if (success != null) {
        _pointsController.clear();
        _showSuccessDialog('Redemption Successful!', 'Your request has been submitted. Reference: ${success['reference_number'] ?? 'N/A'}');
      } else {
        _showError(Provider.of<PointsProvider>(context, listen: false).error ?? 'Redemption failed');
      }
    }
  }

  Future<void> _redeemCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      _showError('Please enter a code');
      return;
    }

    final result = await Provider.of<PointsProvider>(context, listen: false).redeemCode(code);

    if (mounted) {
      if (result != null) {
        _codeController.clear();
        int points = result['points'] ?? 0;
        _showSuccessDialog('Code Redeemed!', 'You have earned $points points!');
      } else {
        _showError(Provider.of<PointsProvider>(context, listen: false).error ?? 'Invalid code');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.success, size: 60),
            const SizedBox(height: 16),
            Text(title),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem'),
      ),
      body: Consumer<PointsProvider>(
        builder: (context, pointsProvider, child) {
          return LoadingOverlay(
            isLoading: pointsProvider.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isScanning)
                     SizedBox(
                      height: 300,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          QRView(
                            key: _qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                              borderColor: AppTheme.primaryBlue,
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 250,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton.icon(
                              onPressed: _toggleScanner,
                              icon: const Icon(Icons.close),
                              label: const Text('Close Scanner'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  // Points redemption section
                  const Text(
                    'Redeem Points',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Available Points',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${pointsProvider.totalPoints}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.account_balance_wallet, color: AppTheme.primaryBlue, size: 32),
                            ],
                          ),
                          const Divider(height: 32),
                          TextFormField(
                            controller: _pointsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Points to redeem',
                              hintText: 'Min 1000 points',
                              prefixIcon: Icon(Icons.card_giftcard),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          CustomButton(
                            onPressed: _redeemPoints,
                            text: 'Redeem Points',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Code redemption section
                  const Text(
                    'Redeem Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _codeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Redemption Code',
                                    hintText: 'Enter code',
                                    prefixIcon: Icon(Icons.vpn_key),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _toggleScanner,
                                icon: const Icon(Icons.qr_code_scanner, size: 30, color: AppTheme.primaryBlue),
                                tooltip: 'Scan QR Code',
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          CustomButton(
                            onPressed: _redeemCode,
                            text: 'Redeem Code',
                            isOutlined: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Generate QR code section
                  const Text(
                    'My QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                          final userId = userProvider.user?.id ?? 'User ID';
                          return Column(
                            children: [
                              Center(
                                child: QrImageView(
                                  data: userId,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              Text(
                                userId,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Scan this QR code to confirm your identity',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}