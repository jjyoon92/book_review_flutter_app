import 'package:book_review_app/src/common/cubit/authentication_cubit.dart';
import 'package:book_review_app/src/common/repository/user_repository.dart';
import 'package:book_review_app/src/detail.dart';
import 'package:book_review_app/src/home.dart';
import 'package:book_review_app/src/home/page/home_page.dart';
import 'package:book_review_app/src/init/page/init_page.dart';
import 'package:book_review_app/src/login/page/login_page.dart';
import 'package:book_review_app/src/root/page/root_page.dart';
import 'package:book_review_app/src/signup/cubit/signup_cubit.dart';
import 'package:book_review_app/src/signup/page/signup_page.dart';
import 'package:book_review_app/src/splash/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      refreshListenable: context.read<AuthenticationCubit>(),
      redirect: (context, state) {
        // print(context.read<AuthenticationCubit>().state.status);
        var authStatus = context.read<AuthenticationCubit>().state.status;
        switch (authStatus) {
          case AuthenticationStatus.authentication:
            // 회원가입 상태에서 로그인 완료.
            return '/home';
          case AuthenticationStatus.unAuthentication:
            return '/signup';
          case AuthenticationStatus.unknown:
            return '/login';
          case AuthenticationStatus.init:
            break;
          case AuthenticationStatus.error:
            break;
        }
        return state.path;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (context) => SignupCubit(context.read<AuthenticationCubit>().state.user!, context.read<UserRepository>()),
            child: const SignupPage(),
          ),
        ),
      ],
    ); //route
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
