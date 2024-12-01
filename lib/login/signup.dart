import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/login/medical_disclaimer_dialog.dart';
import 'package:hane/login/logo.dart';
import 'login_page.dart';
import 'package:hane/app_theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.title});

  final String? title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;
  bool _isLoading = false; // To manage loading state


  void showErrorMessage(String message) async {
    setState(() {
      errorMessage = message;
      _isLoading = false; // Stop loading if there's an error
    });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      errorMessage = null;
    });
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          cursorColor: Theme.of(context).primaryColor,
          controller: controller,
          obscureText: isPassword,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _onSuccessfulRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Du är nu registrerad!"),
    ));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const InitializerWidget(firstLogin: true)),
    );
  }

  void _onFailedRegistration(FirebaseAuthException e) {
    String message;
    if (e.code == 'email-already-in-use') {
      message = 'E-postadressen är redan registrerad.';
    } else if (e.code == 'weak-password') {
      message = 'Lösenordet är för svagt.';
    } else if (e.code == 'invalid-email') {
      message = 'E-postadressen är ogiltig.';
    } else if (e.code == 'invalid-password') {
      message = 'Lösenordet får inte vara tomt.';
    } else {
      message = 'Registreringen misslyckades: ${e.message}';
    }
    showErrorMessage(message);
  }

  Future<void> _validateAndProceed() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Basic validation
    if (email.isEmpty) {
      showErrorMessage('E-postadressen får inte vara tom.');
      return;
    }

    if (password.isEmpty) {
      showErrorMessage('Lösenordet får inte vara tomt.');
      return;
    }

    if (password.length < 6) {
      showErrorMessage('Lösenordet måste vara minst 6 tecken långt.');
      return;
    }

    // Check if email is valid
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      showErrorMessage('E-postadressen är ogiltig.');
      return;
    }

    try {
      // Check if email is already in use
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        showErrorMessage('E-postadressen är redan registrerad.');
        return;
      }

      setState(() {
        _isLoading = false; // Stop loading before showing disclaimer
      });

      // Show the disclaimer dialog
      _showDisclaimerDialog();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      // Handle specific errors if needed
      if (e.code == 'invalid-email') {
        showErrorMessage('E-postadressen är ogiltig.');
      } else {
        showErrorMessage('Ett fel uppstod: ${e.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      showErrorMessage('Ett oväntat fel uppstod.');
    }
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return MedicalDisclaimerDialog(
          onAccepted: () {
            Navigator.of(context).pop(); // Close the disclaimer dialog
            _registerUser(); // Proceed with registration
          },
        );
      },
    );
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true; // Start loading during registration
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _auth.currentUser!.sendEmailVerification();
      setState(() {
        _isLoading = false; // Stop loading after registration
      });
      _onSuccessfulRegistration();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      _onFailedRegistration(e);
    }
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 45), // Full width button
      ),
      onPressed: () {
        // Validate inputs and proceed
        _validateAndProceed();
      },
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text(
              'Registrera dig nu',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Har du redan ett konto?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            Text(
              'Logga in',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("E-post", _emailController),
        _entryField("Lösenord", _passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: appTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
      
              const Logo(size: 30,),
              _title(),
              const SizedBox(height: 50),
              _emailPasswordWidget(),
              const SizedBox(height: 20),
              _submitButton(),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 40),
              _loginAccountLabel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Registrera dig',
      style: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

