import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/login/initializer_widget.dart';
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.title});

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;

  Widget _backButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
void showErrorMessage(String message) async {
  setState(() {
    errorMessage = message;
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

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: Size(double.infinity, 45), // Full width button
      ),
      onPressed: () async {
        try {
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          await _auth.currentUser!.sendEmailVerification();
          _onSuccessfulRegistration();
        } on FirebaseAuthException catch (e) {
          _onFailedRegistration(e);
        }
      },
      child: const Text(
        'Registrera dig nu',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
    final height = 80;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _backButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: height * .05),
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