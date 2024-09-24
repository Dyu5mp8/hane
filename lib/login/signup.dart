// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/login/initializer_widget.dart';
import 'loginPage.dart';
import 'login_background/bezierContainer.dart';

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
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Tillbaka',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  void showErrorMessage(String message) async {
    setState(() {
      errorMessage = message;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      errorMessage = null;
    });
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _onSuccessfulRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Du är nu registrerad!"),
    ));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InitializerWidget(firstLogin: true,)),
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
  }
    else if (e.code == 'invalid-password') {
    message = 'Lösenordet får inte vara tomt.';
  } else {
    message = 'Registreringen misslyckades: ${e.message}';
  }
  setState(() {
    showErrorMessage(message);
  });

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

  Widget _submitButton() {
    return InkWell(
     // In your onTap:
onTap: () async {
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)]),
        ),
        child: const Text(
          'Registrera dig nu',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Har du redan ett konto?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 10),
            Text(
              'Logga in',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Epost", _emailController),
        _entryField("Lösenord", _passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(height: 50),
                    _emailPasswordWidget(),
                    const SizedBox(height: 20),
                    _submitButton(),
                         SizedBox(height: 20),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
               
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Registrera dig',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
    );
  }
}