import 'package:book_review_app/firebase_options.dart';
import 'package:book_review_app/src/common/cubit/app_data_load_cubit.dart';
import 'package:book_review_app/src/common/interceptor/custom_interceptor.dart';
import 'package:book_review_app/src/common/model/naver_book_search_option.dart';
import 'package:book_review_app/src/common/repository/naver_api_repository.dart';
import 'package:book_review_app/src/init/cubit/init_cubit.dart';
import 'package:book_review_app/src/splash/cubit/splash_cubit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InitCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => AppDataLoadCubit(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => SplashCubit(),
          ),
        ],
        child: const App(),
      ),
    );
  }
}
