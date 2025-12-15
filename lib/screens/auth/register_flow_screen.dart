import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterFlowScreen extends StatefulWidget {
  const RegisterFlowScreen({super.key});

  @override
  State<RegisterFlowScreen> createState() => _RegisterFlowScreenState();
}

class _RegisterFlowScreenState extends State<RegisterFlowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _accountType = AppConstants.accountTypeUser;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        accountType: _accountType,
      );

      if (success) {
        // Navigate to OTP verification screen
        if (mounted) {
          Navigator.of(context).pushNamed('/otp-verification');
        }
      } else {
        setState(() {
          _errorMessage = authProvider.error ?? 'Registration failed';
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
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                const Text(
                  'Create your account to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < AppConstants.minNameLength) {
                      return 'Name must be at least ${AppConstants.minNameLength} characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                
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
                const SizedBox(height: AppTheme.spacingM),
                
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!AppConstants.phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < AppConstants.minPasswordLength) {
                      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
                    }
                    if (!AppConstants.passwordRegex.hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                const Text(
                  'Account Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: _accountType == AppConstants.accountTypeUser 
                            ? AppTheme.primaryBlue.withOpacity(0.1) 
                            : AppTheme.cardBackground,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _accountType = AppConstants.accountTypeUser;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 32,
                                  color: _accountType == AppConstants.accountTypeUser 
                                      ? AppTheme.primaryBlue 
                                      : AppTheme.textSecondary,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  'User',
                                  style: TextStyle(
                                    fontWeight: _accountType == AppConstants.accountTypeUser 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    color: _accountType == AppConstants.accountTypeUser 
                                        ? AppTheme.primaryBlue 
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingXS),
                                const Text(
                                  'Earn points by completing tasks',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Card(
                        color: _accountType == AppConstants.accountTypePartner 
                            ? AppTheme.primaryBlue.withOpacity(0.1) 
                            : AppTheme.cardBackground,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _accountType = AppConstants.accountTypePartner;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 32,
                                  color: _accountType == AppConstants.accountTypePartner 
                                      ? AppTheme.primaryBlue 
                                      : AppTheme.textSecondary,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  'Partner',
                                  style: TextStyle(
                                    fontWeight: _accountType == AppConstants.accountTypePartner 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    color: _accountType == AppConstants.accountTypePartner 
                                        ? AppTheme.primaryBlue 
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingXS),
                                const Text(
                                  'Offer tasks and rewards to users',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  text: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Already have an account? Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}