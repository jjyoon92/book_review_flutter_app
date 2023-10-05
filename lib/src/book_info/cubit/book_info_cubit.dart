import 'package:bloc/bloc.dart';
import 'package:book_review_app/src/common/enum/common_state_status.dart';
import 'package:book_review_app/src/common/model/book_review_info.dart';
import 'package:book_review_app/src/common/model/user_model.dart';
import 'package:book_review_app/src/common/repository/book_review_info_repository.dart';
import 'package:book_review_app/src/common/repository/user_repository.dart';
import 'package:equatable/equatable.dart';

class BookInfoCubit extends Cubit<BookInfoState> {
  final BookReviewInfoRepository _bookReviewInfoRepository;
  final UserRepository _userRepository;
  final String bookId;
  final String uid; // 리뷰 작성 여부 확인을 위한 uid
  BookInfoCubit(
    this._bookReviewInfoRepository,
    this._userRepository,
    this.bookId,
    this.uid,
  ) : super(const BookInfoState()) {
    _loadBookReviewInfo();
  }

  void refresh() {
    _loadBookReviewInfo();
  }

  void _loadBookReviewInfo() async {
    emit(state.copyWith(status: CommonStateStatus.loading));
    var data = await _bookReviewInfoRepository.loadBookReviewInfo(bookId);
    if (data != null) {
      //리뷰 정보가 있는 상태
      if (data.reviewerUids!.isEmpty) return;
      var reviewList =
      await _userRepository.allUserInfos(data.reviewerUids ?? []);
      emit(state.copyWith(
        status: CommonStateStatus.loaded,
        bookReviewInfo: data,
        reviewers: reviewList,
      ));
    } else {
      emit(state.copyWith(status: CommonStateStatus.loaded));
    }
  }
}

class BookInfoState extends Equatable {
  final BookReviewInfo? bookReviewInfo;
  final List<UserModel>? reviewers;
  final CommonStateStatus status;

  const BookInfoState({
    this.bookReviewInfo,
    this.reviewers,
    this.status = CommonStateStatus.init,
  });

  BookInfoState copyWith({
    List<UserModel>? reviewers,
    BookReviewInfo? bookReviewInfo,
    CommonStateStatus? status,
  }) {
    return BookInfoState(
      bookReviewInfo: bookReviewInfo ?? this.bookReviewInfo,
      reviewers: reviewers ?? this.reviewers,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [reviewers, bookReviewInfo, status];
}
