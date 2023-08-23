import 'package:book_review_app/src/detail.dart';
import 'package:book_review_app/src/home.dart';
import 'package:book_review_app/src/init/page/init_page.dart';
import 'package:book_review_app/src/login/page/login_page.dart';
import 'package:book_review_app/src/root/page/root_page.dart';
import 'package:book_review_app/src/splash/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
      ],
    );
    //route
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xff1c1c1c),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff1c1c1c),
      ),
    );
  }
}
