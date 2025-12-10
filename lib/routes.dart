import 'package:flutter/widgets.dart';
import 'package:library_app/views/admin/book/admin_book_list.dart';
import 'package:library_app/views/admin/category/add_category.dart';
import 'package:library_app/views/admin/category/admin_category_list.dart';
import 'package:library_app/views/admin/dashboard.dart';
import 'package:library_app/views/admin/user/admin_user_list.dart';
import 'package:library_app/views/book/add_book.dart';
import 'package:library_app/views/book/book_details.dart';
import 'package:library_app/views/splash/splash_screen.dart';

import 'views/home/home_screen.dart';
import 'views/init_screen.dart';
import 'views/auth/sign_in_screen.dart';
import 'views/auth/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  AddBookScreen.routeName: (context) => const AddBookScreen(),
  BookDetailsScreen.routeName: (context) => const BookDetailsScreen(),
  AddCategoryScreen.routeName: (context) => const AddCategoryScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  AdminBookList.routeName: (context) => const AdminBookList(),
  AdminCategoryList.routeName : (context) => const AdminCategoryList(),
  AdminUserList.routeName: (context) => const AdminUserList(),
};
