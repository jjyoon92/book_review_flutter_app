import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:book_review_app/src/common/model/user_model.dart';
import 'package:book_review_app/src/common/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserRepository _userRepository;

  SignupCubit(UserModel userModel, this._userRepository)
      : super(SignupState(userModel: userModel));

  void changeProfileImage(XFile? image) {
    if (image == null) return;
    var file = File(image.path);
    emit(state.copyWith(profileFile: file));
  }

  void changeNickname(String nickname) {
    emit(state.copyWith(nickname: nickname));
  }

  void changeDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateProfileImageUrl(String url) {
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        userModel: state.userModel!.copyWith(profile: url),
      ),
    );
    submit();
  }

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }

  void save() {
    if (state.nickname == null || state.nickname == '') return;
    emit(state.copyWith(status: SignupStatus.loading));
    if (state.profileFile != null) {
      emit(state.copyWith(status: SignupStatus.uploading));
    } else {
      submit();
    }
  }

  void submit() async {
    var joinUserModel = state.userModel!.copyWith(
      name: state.nickname,
      description: state.description,
    );
    var result = await _userRepository.joinUser(joinUserModel);
    if (result) {
      emit(state.copyWith(status: SignupStatus.success));
    } else {
      emit(state.copyWith(status: SignupStatus.fail));
    }
  }
}

enum SignupStatus {
  init,
  loading,
  uploading,
  success,
  fail,
}

class SignupState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? description;
  final String? percent;
  final SignupStatus status;
  final UserModel? userModel;

  const SignupState({
    this.profileFile,
    this.nickname,
    this.description,
    this.percent,
    this.status = SignupStatus.init,
    this.userModel,
  });

  copyWith({
    File? profileFile,
    String? nickname,
    String? description,
    String? percent,
    SignupStatus? status,
    UserModel? userModel,
  }) {
    return SignupState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      percent: percent ?? this.percent,
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [
        profileFile,
        nickname,
        description,
        percent,
        status,
        userModel,
      ];
}
