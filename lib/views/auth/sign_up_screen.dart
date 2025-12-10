import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/views/home/home_screen.dart';
import '../../constants.dart';
import '../../models/user.dart'; // import AppUser

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(child: _SignUpForm()),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  String? name;
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() => isLoading = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      final user = userCredential.user;
      if (user != null) {
        final appUser = AppUser(
  id: user.uid,
  email: email!,
  name: name ?? "",
  role: "user", 
  borrowedBooks: [], 
);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(appUser.toMap());

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text("Register Account", style: headingStyle),
        const Text(
          "Complete your details or continue\nwith social media",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              TextFormField(
                onSaved: (v) => name = v?.trim(),
                validator: (v) => v == null || v.isEmpty ? "Name required" : null,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.person, size: 20),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

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
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                obscureText: true,
                onSaved: (v) => password = v,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password required";
                  if (value.length < 8) return "Minimum 8 characters";
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.lock, size: 20),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextFormField(
                obscureText: true,
                onSaved: (v) => confirmPassword = v,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please confirm password";
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Re-enter your password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.lock, size: 20),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (password == confirmPassword) {
                            registerUser();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Passwords do not match")),
                            );
                          }
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Continue"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Text(
          'By continuing you confirm that you agree\nwith our Terms and Conditions',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
