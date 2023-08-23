import 'package:hydrated_bloc/hydrated_bloc.dart';

class InitCubit extends HydratedCubit<bool>{
  InitCubit() : super(false);

  void startApp() {
    emit(true);
  }

  @override
  bool fromJson(Map<String, dynamic> json) => json['state'] as bool;

  @override
  Map<String, bool> toJson(bool state) => { 'state': state };
}

// 사용자가 Start 버튼을 누르면 true로 업데이트 되면서 자동적으로 local storage에 true로 저장이되고
// 다른 페이지가 뜨게 된다.