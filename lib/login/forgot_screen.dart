import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/app_theme.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// This method sends the password reset email using Firebase Auth
  Future<void> _sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // If successful, show a confirmation
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Check your email'),
              content: const Text(
                'A password reset link has been sent to your email.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Hoppsan, något gick fel.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Hoppsan, något gick fel.';
      });
    }
  }

  void _onSubmit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      await _sendPasswordResetEmail(email);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('Glömt lösenord')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Ange din e-postadress för att återställa ditt lösenord',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-postadress',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ange en e-postadress';
                              }
                              // Add more email validation if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _onSubmit,
                            child: const Text('Skicka återställningslänk'),
                          ),
                          const SizedBox(height: 16),
                          if (_errorMessage.isNotEmpty)
                            Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
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
