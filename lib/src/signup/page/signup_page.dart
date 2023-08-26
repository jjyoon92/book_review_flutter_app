import 'dart:io';

import 'package:book_review_app/src/common/components/app_font.dart';
import 'package:book_review_app/src/common/components/btn.dart';
import 'package:book_review_app/src/common/components/loading.dart';
import 'package:book_review_app/src/common/cubit/authentication_cubit.dart';
import 'package:book_review_app/src/common/cubit/upload_cubit.dart';
import 'package:book_review_app/src/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  Widget _signupView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset('assets/svg/icons/icon_close.svg'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _UserProfileImageField(),
              const SizedBox(height: 50),
              const _NicknameField(),
              const SizedBox(height: 30),
              const _DescriptionField(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: Btn(
                onTap: context.read<SignupCubit>().save,
                text: '가입',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Btn(
                onTap: () {},
                backgroundColor: const Color(0xff212121),
                text: '취소',
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignupCubit, SignupState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case SignupStatus.init:
                break;
              case SignupStatus.loading:
                break;
              case SignupStatus.uploading:
                context.read<UploadCubit>().uploadUserProfile(
                    state.profileFile!, state.userModel!.uid!);
                break;
              case SignupStatus.success:
                context.read<AuthenticationCubit>().reloadAuth();
                break;
              case SignupStatus.fail:
                break;
            }
          },
        ),
        BlocListener<UploadCubit, UploadState>(
          listener: (context, state) {
            switch (state.status) {
              case UploadStatus.init:
                break;
              case UploadStatus.uploading:
                context
                    .read<SignupCubit>()
                    .uploadPercent(state.percent!.toStringAsFixed(2));
                break;
              case UploadStatus.success:
                context.read<SignupCubit>().updateProfileImageUrl(state.url!);
                break;
              case UploadStatus.fail:
                break;
            }
          },
        ),
      ],
      child: Stack(
        children: [
          _signupView(context),
          BlocBuilder<SignupCubit, SignupState>(
            buildWhen: (previous, current) =>
                previous.percent != current.percent ||
                previous.status != current.status,
            builder: (context, state) {
              if (state.percent != null &&
                  state.status == SignupStatus.uploading) {
                return Loading(loadingMessage: '${state.percent}%');
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

// 프로필 이미지
class _UserProfileImageField extends StatelessWidget {
  _UserProfileImageField({super.key});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var profileFile =
        context.select<SignupCubit, File?>((cubit) => cubit.state.profileFile);
    return Center(
      child: GestureDetector(
        onTap: () async {
          var image = await _picker.pickImage(source: ImageSource.gallery);
          context.read<SignupCubit>().changeProfileImage(image);
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 50,
          backgroundImage: profileFile == null
              ? Image.asset('assets/images/default_avatar.png').image
              : Image.file(profileFile).image,
        ),
      ),
    );
  }
}

class _NicknameField extends StatelessWidget {
  const _NicknameField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppFont(
          '닉네임',
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          onChanged: context.read<SignupCubit>().changeNickname,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff232323),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppFont(
          '한줄 소개',
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          onChanged: context.read<SignupCubit>().changeDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          maxLength: 50,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff232323),
            counterStyle: const TextStyle(color: Colors.white, fontSize: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
