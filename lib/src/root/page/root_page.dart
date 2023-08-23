import 'package:book_review_app/src/init/cubit/init_cubit.dart';
import 'package:book_review_app/src/init/page/init_page.dart';
import 'package:book_review_app/src/splash/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
* 초기 값에 따라서 초기페이지인지, 스플래시페이지인지 분기
**/

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitCubit, bool>(
      builder: (context, state) {
        return state ? const SplashPage() : const InitPage();
      },
    );
  }
}
