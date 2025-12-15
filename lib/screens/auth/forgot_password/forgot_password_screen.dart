import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.forgotPassword(_emailController.text.trim());

      if (success) {
        setState(() {
          _emailSent = true;
        });
      } else {
        setState(() {
          _errorMessage = authProvider.error ?? 'Failed to send reset link';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_reset,
                size: 80,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: AppTheme.spacingL),
              const Text(
                'Reset Your Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              const Text(
                'Enter your email and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              if (_emailSent) ...[
                Icon(
                  Icons.check_circle,
                  size: 60,
                  color: AppTheme.success,
                ),
                const SizedBox(height: AppTheme.spacingM),
                const Text(
                  'Reset Link Sent!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                const Text(
                  'We\'ve sent a password reset link to your email. Please check your inbox.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                CustomButton(
                  text: 'Back to Login',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ] else ...[
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!AppConstants.emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
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
                  text: 'Send Reset Link',
                  isLoading: _isLoading,
                  onPressed: _handleForgotPassword,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}