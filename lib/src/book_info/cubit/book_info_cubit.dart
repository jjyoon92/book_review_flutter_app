import 'package:bloc/bloc.dart';
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
  ) : super(BookInfoState()) {
    _loadBookReviewInfo();
  }

  void _loadBookReviewInfo() async {
    var data = _bookReviewInfoRepository.loadBookReviewInfo(bookId);
    if(data != null) {
      // 리뷰 정보가 있는 상태

    }
  }

}

class BookInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}
