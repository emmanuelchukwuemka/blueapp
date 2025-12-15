import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    AppConstants.otpLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    AppConstants.otpLength,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  bool _verificationSuccess = false;
  String? _errorMessage;
  int _resendTime = AppConstants.otpResendTime;
  bool _canResend = false;
  late String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber = '+1 (555) 123-4567'; // This would come from previous screen
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
    });

    Future.delayed(const Duration(seconds: AppConstants.otpResendTime), () {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length != AppConstants.otpLength) {
      setState(() {
        _errorMessage = 'Please enter a valid OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyOtp(_phoneNumber, otp);

      if (success) {
        setState(() {
          _verificationSuccess = true;
        });
        
        // Navigate to home after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        });
      } else {
        setState(() {
          _errorMessage = authProvider.error ?? 'Failed to verify OTP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleResendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resendOtp(_phoneNumber);

      if (success) {
        setState(() {
          _errorMessage = 'OTP resent successfully';
          _canResend = false;
        });
        _startResendTimer();
        
        // Clear OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      } else {
        setState(() {
          _errorMessage = authProvider.error ?? 'Failed to resend OTP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOtpChanged(int index) {
    final text = _otpControllers[index].text;
    
    if (text.length == 1) {
      // Move to next field
      if (index < AppConstants.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, auto-submit
        _focusNodes[index].unfocus();
        _handleVerifyOtp();
      }
    } else if (text.isEmpty && index > 0) {
      // Move to previous field
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sms,
              size: 80,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: AppTheme.spacingL),
            const Text(
              'Verification Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Please enter the 6-digit code sent to $_phoneNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            if (_verificationSuccess) ...[
              Icon(
                Icons.check_circle,
                size: 80,
                color: AppTheme.success,
              ),
              const SizedBox(height: AppTheme.spacingM),
              const Text(
                'Verification Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              const Text(
                'Redirecting to home...',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(AppConstants.otpLength, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(index),
                    ),
                  );
                }),
              ),
              
              if (_errorMessage != null) ...[
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppTheme.error,
                    fontSize: 14,
                  ),
                ),
              ],
              
              const SizedBox(height: AppTheme.spacingL),
              CustomButton(
                text: 'Verify',
                isLoading: _isLoading,
                onPressed: _handleVerifyOtp,
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResend 
                        ? 'Didn\'t receive the code?' 
                        : 'Resend code in $_resendTime seconds',
                    style: TextStyle(
                      color: _canResend ? AppTheme.primaryBlue : AppTheme.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend ? _handleResendOtp : null,
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        color: _canResend ? AppTheme.primaryBlue : AppTheme.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}