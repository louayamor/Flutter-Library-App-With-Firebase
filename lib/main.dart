import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_app/controllers/category_controller.dart';
import 'package:library_app/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/book_controller.dart';
import 'routes.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<CategoryController>(
          create: (_) => CategoryController(),
        ),
        ChangeNotifierProvider<BookController>(
          create: (_) => BookController(),
        ),
       

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Library App',
        theme: AppTheme.lightTheme(context),
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
