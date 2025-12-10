import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/views/admin/dashboard.dart';
import '../../constants.dart';
import '../auth/sign_in_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  String? username;
  String? errorMessage;
  bool showWelcome = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController!);

    _animationController!.forward();

    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await Future.delayed(const Duration(seconds: 1));

      if (user == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, SignInScreen.routeName);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = doc.data()?['role'] ?? 'user';
      username = doc.data()?['username'] ?? 'User';

      setState(() {
        showWelcome = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong. Please try again.";
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              if (_fadeAnimation != null)
                FadeTransition(
                  opacity: _fadeAnimation!,
                  child: Center(
                    child: Image.asset(
                      "assets/images/book_design.jpg",
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                ),
              if (errorMessage != null)
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else if (showWelcome)
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Welcome, $username!",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                )
              else
                const Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
