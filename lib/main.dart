import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/book_controller.dart';
import 'controllers/category_controller.dart';
import 'routes.dart';
import 'theme.dart';
import 'views/splash/splash_screen.dart';

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
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => BookController()),
      ],
      child: MaterialApp(
        title: 'Library App',
        debugShowCheckedModeBanner: false,

        // ✅ Theme handled centrally
        theme: AppTheme.lightTheme(),

        // Optional: prepare for dark mode later
        // darkTheme: AppTheme.darkTheme(),
        // themeMode: ThemeMode.system,

        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
