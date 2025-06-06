import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../shared/theme.dart' as app_theme;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 1. Add state variable for password visibility
  bool _obscurePassword = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      print('Login attempt with Email: $email, Password: $password');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    'Sign In',
                    style: app_theme.blackTextStyle
                        .copyWith(fontSize: 30, fontWeight: app_theme.bold),
                  ),
                  const SizedBox(height: 20),
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
                  
                  // 2. & 3. Update the password TextFormField
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
                          color: app_theme.kBlackColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword, // Use the state variable
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
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('or continue with',
                            style: app_theme.primaryTextStyle.copyWith(
                                color: app_theme.kBlackColor.withOpacity(0.6))),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: Image.asset(
                        'assets/images/flat-color-icons_google.png',
                        height: 20,
                        width: 20),
                    label: Text('Login with Google',
                        style: app_theme.blackTextStyle
                            .copyWith(fontWeight: app_theme.semiBold)),
                    onPressed: () {/* TODO: Implement Google Sign In */},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      side: BorderSide(
                          color: app_theme.kPrimaryColor.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(app_theme.defaultRadius),
                      ),
                      backgroundColor: app_theme.kWhiteColor,
                    ),
                  ),
                  SizedBox(height: app_theme.defaultMargin),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: app_theme.primaryTextStyle),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text('Register.',
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