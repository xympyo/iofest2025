import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'login_screen.dart';
import '../shared/theme.dart' as app_theme;
import '../api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  String? _errorMessage;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      final result = await ApiService.register(
        username,
        email,
        password,
        _confirmPasswordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (result['success']) {
        // TODO: Store token securely (e.g. with flutter_secure_storage)
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Registration failed';
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(app_theme.defaultMargin),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Updated Logo and App Name Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Artboard 1@4xActualLogo 1.png',
                        height: 50,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TappyTale',
                        style: GoogleFonts.montserrat(
                          color: app_theme.kSecondaryColor,
                          fontSize: 24,
                          fontWeight: app_theme.bold,
                        ),
                      ),
                    ],
                  ),
                  // End of Updated Section

                  const SizedBox(height: 24),
                  Text(
                    'Welcome to TappyTale',
                    textAlign: TextAlign.center,
                    style: app_theme.blackTextStyle
                        .copyWith(fontSize: 26, fontWeight: app_theme.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up or Log In below to start making your\nchildren day better. Or create storybook for parents.',
                    textAlign: TextAlign.center,
                    style: app_theme.primaryTextStyle.copyWith(
                        color: app_theme.kBlackColor.withOpacity(0.7),
                        height: 1.5),
                  ),
                  SizedBox(height: app_theme.defaultMargin * 1.2),
                  Text(
                    'Sign Up',
                    style: app_theme.blackTextStyle
                        .copyWith(fontSize: 30, fontWeight: app_theme.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person_outline,
                          color: app_theme.kBlackColor.withOpacity(0.5)),
                      fillColor: app_theme.kPrimaryLightColor,
                    ),
                    style: app_theme.primaryTextStyle,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter your username'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: app_theme.kBlackColor.withOpacity(0.5)),
                      fillColor: app_theme.kPrimaryLightColor,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: app_theme.primaryTextStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline,
                          color: app_theme.kBlackColor.withOpacity(0.5)),
                      fillColor: app_theme.kPrimaryLightColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: app_theme.kBlackColor.withOpacity(0.5)),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    style: app_theme.primaryTextStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      prefixIcon: Icon(Icons.lock_outline,
                          color: app_theme.kBlackColor.withOpacity(0.5)),
                      fillColor: app_theme.kPrimaryLightColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: app_theme.kBlackColor.withOpacity(0.5)),
                        onPressed: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    style: app_theme.primaryTextStyle,
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {/* TODO: Implement forgot password */},
                      child: Text('Forgot password?',
                          style: app_theme.primaryTextStyle.copyWith(
                              fontSize: 13, fontWeight: app_theme.medium)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign Up'),
                  ),
                  SizedBox(height: app_theme.defaultMargin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style: app_theme.primaryTextStyle),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text('Sign In.',
                            style: app_theme.primaryTextStyle.copyWith(
                                color: app_theme.kPrimaryColor,
                                fontWeight: app_theme.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
