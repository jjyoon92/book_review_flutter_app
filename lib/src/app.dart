import 'package:book_review_app/src/book_info/page/book_info_page.dart';
import 'package:book_review_app/src/common/cubit/authentication_cubit.dart';
import 'package:book_review_app/src/common/model/naver_book_info.dart';
import 'package:book_review_app/src/common/repository/book_review_info_repository.dart';
import 'package:book_review_app/src/common/repository/naver_api_repository.dart';
import 'package:book_review_app/src/common/repository/review_repository.dart';
import 'package:book_review_app/src/common/repository/user_repository.dart';
import 'package:book_review_app/src/detail.dart';
import 'package:book_review_app/src/home.dart';
import 'package:book_review_app/src/home/page/home_page.dart';
import 'package:book_review_app/src/init/page/init_page.dart';
import 'package:book_review_app/src/login/page/login_page.dart';
import 'package:book_review_app/src/review/cubit/review_cubit.dart';
import 'package:book_review_app/src/review/page/review_page.dart';
import 'package:book_review_app/src/root/page/root_page.dart';
import 'package:book_review_app/src/search/cubit/search_book_cubit.dart';
import 'package:book_review_app/src/search/page/search_page.dart';
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
        // authentication 상태에서 다른 페이지로 넘어갈때 '/home'으로 리다이렉트 되는 현상을 방지하기 위하여
        // 아래의 경로로 이동할 때만 '/home' 경로로 리다이렉트 시킨다.
        var blockPageInAuthenticationState = ['/', '/login', '/signup'];
        print(state.matchedLocation);
        switch (authStatus) {
          case AuthenticationStatus.authentication:
            // 회원가입 상태에서 로그인 완료.
            return blockPageInAuthenticationState
                    .contains(state.matchedLocation)
                ? '/home'
                : state.matchedLocation;
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
          path: '/info',
          builder: (context, state) =>
              BookInfoPage(state.extra as NaverBookInfo),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => BlocProvider(
            create: (context) {
              var bookInfo = state.extra as NaverBookInfo;
              var uid = context.read<AuthenticationCubit>().state.user!.uid!;
              return ReviewCubit(
                  context.read<BookReviewInfoRepository>(),
                  context.read<ReviewRepository>(), uid, bookInfo);
            },
            child: ReviewPage(state.extra as NaverBookInfo),
          ),
        ),
        GoRoute(
            path: '/search',
            builder: (context, state) => BlocProvider(
                create: (context) =>
                    SearchBookCubit(context.read<NaverBookRepository>()),
                child: const SearchPage())),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (context) => SignupCubit(
                context.read<AuthenticationCubit>().state.user!,
                context.read<UserRepository>()),
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
