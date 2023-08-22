import 'package:book_review_app/src/common/interceptor/custom_interceptor.dart';
import 'package:book_review_app/src/common/repository/naver_api_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';

void main() {
  Dio dio = Dio(BaseOptions(baseUrl: 'https://openapi.naver.com/'));
  dio.interceptors.add(CustomInterceptor());
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;
  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => NaverBookRepository(dio),
        ),
      ],
      child: Builder(
        builder: (context) => FutureBuilder(
          future: context.read<NaverBookRepository>().searchBooks(),
          builder: (context, snapshot) {
            return Container();
          },
        ),
      ),
      // child: MultiBlocProvider(
      //   providers: [],
      //   child: App(),
      // ),
    );
  }
}
