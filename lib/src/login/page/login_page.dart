import 'package:book_review_app/src/common/components/app_font.dart';
import 'package:book_review_app/src/common/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Widget _googleLoginBtn(BuildContext context) {
    return GestureDetector(
      onTap: context.read<AuthenticationCubit>().googleLogin,
      child: Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 40,
            child: SvgPicture.asset('assets/svg/icons/google_logo.svg'),
          ),
          const AppFont(
            'Google로 계속하기',
            color: Colors.black,
            size: 14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),);
  }

  Widget _appleLoginBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 300,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 40,
              child: SvgPicture.asset('assets/svg/icons/apple_logo.svg'),
            ),
            const AppFont(
              'Apple로 계속하기',
              size: 14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          'assets/images/login_bg.png',
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.6),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Column(
                  children: [
                    AppFont(
                      'Book & Review',
                      size: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AppFont(
                      '여러분의 감상을 리뷰로 작성하고\n다른 사람들과 공유해보세요.',
                      size: 13,
                      color: Color(0xffd7d7d7),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const AppFont(
                      '회원가입/로그인',
                      size: 14,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    _googleLoginBtn(context),
                    const SizedBox(
                      height: 10,
                    ),
                    _appleLoginBtn(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
