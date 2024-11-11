import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hane/login/initializer_widget.dart';
import 'package:hane/login/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title, this.emailNotVerified});

  final String? title;
  final bool? emailNotVerified;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color accentColor = const Color.fromARGB(255, 41, 51, 81);

  bool _isLoading = false;
  bool _rememberMe = false; // Add "Remember Me" variable

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // Load email and "Remember Me" preference
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load saved email and "Remember Me" checkbox state
  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('user_email') ?? '';
      }
    });
  }

  _saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', value);
  }

  // Save email and "Remember Me" checkbox state
  Future<void> _saveUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      prefs.setString('user_email', _emailController.text);
    } else {
      prefs.remove('user_email');
    }
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          _isLoading = true;
        });

        try {
          await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          await _saveUserEmail();
          if(mounted) {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InitializerWidget()),
          );
          }
        } on FirebaseAuthException catch (e) {
          _onFailedLogin(e);
        } catch (e) {
          // Handle other exceptions
          print('An unexpected error occurred: $e');
          if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ett oväntat fel inträffade.")),
          );
          }
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width / 2.5,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 47, 52, 108),
              Color.fromARGB(255, 65, 79, 106),
            ],
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Logga in',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
      ),
    );
  }

  void _onFailedLogin(FirebaseAuthException e) {
    final errorMessages = {
      'user-not-found': 'Användaren finns inte.',
      'wrong-password': 'Användare eller lösenord felaktigt',
      'invalid-email': 'Ogiltig e-postadress',
      'missing-password': 'Lösenord saknas',
      'invalid-credential': 'Fel användarnamn eller lösenord',
    };

    String message = errorMessages[e.code] ?? 'Kunde inte logga in.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Email & Password input field with autofill hints
  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, String? autofillHint}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextField(
            controller: controller,
            obscureText: isPassword,
            autofillHints: autofillHint != null ? [autofillHint] : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              fillColor: Color.fromARGB(255, 232, 232, 255),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  // Remember Me checkbox widget
  Widget _rememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
              _saveRememberMe(_rememberMe);
            });
          },
        ),
        const Text("Kom ihåg mig"),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("E-post", _emailController,
            autofillHint: AutofillHints.email),
        _entryField("Lösenord", _passwordController,
            isPassword: true, autofillHint: AutofillHints.password),
        _rememberMeCheckbox(), // Add "Remember Me" checkbox here
      ],
    );
  }

  // Title and other UI widgets
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '',
        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
        children: [
          TextSpan(
            text: 'Anestesi',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  fontSize: 50,
                ),
          ),
          TextSpan(
            text: 'H',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 112, 30),
                  fontSize: 50,
                ),
          ),
        ],
      ),
    );
  }
Widget _createAccountLabel() {
  return InkWell(
    onTap: () {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Inget konto ännu?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center, // Center-align the text
          ),
          const SizedBox(height: 10), // Add space between texts
          Text(
            'Registrera ny användare',
            style: TextStyle(
              color: accentColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center, // Center-align the text
          ),
        ],
      ),
    ),
  );
}
 @override
Widget build(BuildContext context) {
  final height = MediaQuery.sizeOf(context).height;

  return Scaffold(
    resizeToAvoidBottomInset: false, // Prevents resizing when the keyboard opens
    body: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight, // Fixed height to avoid resizing
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/concrete.jpg"), // Set your image path here
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Gradient overlay for smooth fade effect
              Container(
                height: constraints.maxHeight, // Fixed height for gradient
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.transparent, // Start with transparent at the top
                      Color.fromARGB(
                          255, 203, 223, 254), // Fade to white at the bottom
                    ],
                    stops: [0, 0.8],
                  ),
                ),
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
                      const SizedBox(height: 10),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
}
