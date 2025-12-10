import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/views/admin/dashboard.dart';
import 'package:library_app/views/auth/sign_up_screen.dart';
import 'package:library_app/views/home/home_screen.dart';
import '../../../constants.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _SignInForm(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextButton(
          onPressed: () {},
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Navigator.pushNamed(context, SignUpScreen.routeName);
              },
              child: const Text(
                "Don’t have an account? Sign Up",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  const _SignInForm();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      // Get role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      final role = userDoc.data()?['role'] ?? 'user'; // default role = user

      if (!mounted) return;

      // Navigate based on role
      if (role == 'admin') {
        Navigator.pushNamedAndRemoveUntil(
            context, DashboardScreen.routeName, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (v) => email = v,
            validator: (value) {
              if (value == null || value.isEmpty) return "Email required";
              if (!emailValidatorRegExp.hasMatch(value)) return "Invalid email";
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.email, size: 20),
            ),
          ),
          const SizedBox(height: 20),

          // Password
          TextFormField(
            obscureText: true,
            onSaved: (v) => password = v,
            validator: (value) {
              if (value == null || value.isEmpty) return "Password required";
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.lock, size: 20),
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      login();
                    }
                  },
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
