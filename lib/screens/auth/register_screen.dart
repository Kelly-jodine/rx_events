import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';

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
  final _rePasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureRePassword = true;

  bool isValidPassword(String password) {
    final capitalLetters =
        RegExp(r'[A-Z]').allMatches(password).length;

    final smallLetters =
        RegExp(r'[a-z]').allMatches(password).length;

    final numbers =
        RegExp(r'[0-9]').allMatches(password).length;

    final specialCharacters =
        RegExp(r'[^A-Za-z0-9]').allMatches(password).length;

    return password.length >= 10 &&
        capitalLetters >= 3 &&
        smallLetters >= 3 &&
        numbers >= 2 &&
        specialCharacters >= 2;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Register'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const Icon(
                Icons.person_add_outlined,
                size: 80,
                color: AppColors.primary,
              ),

              const SizedBox(height: 20),

              const Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Register to start managing your events',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 35),

              // USERNAME
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icon(
                    Icons.person_outline,
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter your username';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // EMAIL
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter your email';
                  }

                  final emailRegex =
                      RegExp(r'^[^@]+@[^@]+\.[^@]+$');

                  if (!emailRegex.hasMatch(text)) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter your password';
                  }

                  if (!isValidPassword(text)) {
                    return 'Password must contain:\n'
                        '10 characters, 3 uppercase, 3 lowercase,\n'
                        '2 numbers and 2 special characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              TextFormField(
                controller: _rePasswordController,
                obscureText: obscureRePassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureRePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureRePassword =
                            !obscureRePassword;
                      });
                    },
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please confirm your password';
                  }

                  if (text != _passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),
              ),

              const SizedBox(height: 15),

              // LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}