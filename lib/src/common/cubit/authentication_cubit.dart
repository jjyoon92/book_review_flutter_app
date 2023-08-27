import 'package:bloc/bloc.dart';
import 'package:book_review_app/src/common/model/user_model.dart';
import 'package:book_review_app/src/common/repository/authentication_repository.dart';
import 'package:book_review_app/src/common/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> with ChangeNotifier {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  AuthenticationCubit(this._authenticationRepository, this._userRepository)
      : super(const AuthenticationState());

  void init() {
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  // 유저 로그인/로그아웃 상태
  // _userStateChangedEvent 에서 넘어온 user 정보의 경우 firebase sns로그인이 완료되었는지에 대한 정보만 넘겨준다.
  // SNS로그인이 된다고해도 database user 정보가 있는지에 따라 회원가입 페이지로 넘길지, 메인 페이지로 넘길지 처리가 필요하다.
  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      emit(state.copyWith(status: AuthenticationStatus.unknown));
    } else {
      var result = await _userRepository
          .findUserOne(user.uid!); // 로그인이 된 상태이므로 user테이블이 있으므로 uid! 로 강제 추출.
      if (result == null) {
        // Google 로그인은 됐으나 회원가입은 안되어 있을 때, firebase에 uid 조회결과가 없음.
        emit(state.copyWith(user: user, status: AuthenticationStatus.unAuthentication));
      } else {
        emit(state.copyWith(
          user: result,
          status: AuthenticationStatus.authentication,
        ));
      }
    }

    notifyListeners();
  }

  void reloadAuth() {
    _userStateChangedEvent(state.user);
  }

  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
  }

  void appleLogin() async {
    await _authenticationRepository.signInWithApple();
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
    print(change);
  }

}

enum AuthenticationStatus {
  authentication,
  unAuthentication,
  unknown,
  init,
  error,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;

  // 초기값을 unkown으로 하게되면 바로 로그인 페이지로 이동하기때문에 init을 추가하여 처음엔 init이고
  // 로그인 체크를 하면서 unkown이 확인되면 로그인 페이지로 보낸다.
  const AuthenticationState({
    this.status = AuthenticationStatus.init,
    this.user,
  });

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    UserModel? user,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status];
}
