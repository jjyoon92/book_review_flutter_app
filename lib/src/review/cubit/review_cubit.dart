import 'package:bloc/bloc.dart';
import 'package:book_review_app/src/common/model/book_review_info.dart';
import 'package:book_review_app/src/common/model/naver_book_info.dart';
import 'package:book_review_app/src/common/model/review.dart';
import 'package:book_review_app/src/common/repository/book_review_info_repository.dart';
import 'package:book_review_app/src/common/repository/review_repository.dart';
import 'package:equatable/equatable.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final BookReviewInfoRepository _bookReviewInfoRepository;
  final ReviewRepository _reviewRepository;

  ReviewCubit(this._bookReviewInfoRepository, this._reviewRepository,
      String uid, NaverBookInfo naverBookInfo)
      : super(ReviewState(
    reviewInfo: Review(
        bookId: naverBookInfo.isbn,
        reviewerUid: uid,
        naverBookInfo: naverBookInfo),
  ));

  changeValue(double value) {
    emit(state.copyWith(reviewInfo: state.reviewInfo!.copyWith(value: value)));
  }

  changeReview(String review) {
    emit(
        state.copyWith(reviewInfo: state.reviewInfo!.copyWith(review: review)));
  }

  save() async {
    var bookId = state.reviewInfo!.bookId!;
    var bookReviewInfo = await _bookReviewInfoRepository.loadBookReviewInfo(
        bookId);
    if (bookReviewInfo == null) {
      // insert
      var bookReviewInfo = BookReviewInfo(
        bookId: bookId,
        totalCounts: state.reviewInfo!.value,
        naverBookInfo: state.reviewInfo!.naverBookInfo!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        reviewerUids: [state.reviewInfo!.reviewerUid!],
      );
      _bookReviewInfoRepository.createBookReviewInfo(bookReviewInfo);
    } else {
      // update
      bookReviewInfo.reviewerUids!.add(state.reviewInfo!.reviewerUid!);
      bookReviewInfo = bookReviewInfo.copyWith(
        totalCounts: bookReviewInfo.totalCounts! + state.reviewInfo!.value!,
        reviewerUids: bookReviewInfo.reviewerUids!.toSet().toList(), // 수정 작업시 중복된 uid가 있을 시 중복이 발생하지 않도록.
        updatedAt: DateTime.now(),
      );
      _bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }

    // var now = DateTime.now();
    // emit(state.copyWith(
    //     reviewInfo:
    //     state.reviewInfo!.copyWith(createdAt: now, updatedAt: now)));
    // await _reviewRepository.createReview(state.reviewInfo!);
  }
}

class ReviewState extends Equatable {
  final Review? reviewInfo;

  const ReviewState({
    this.reviewInfo,
  });

  ReviewState copyWith({
    Review? reviewInfo,
  }) {
    return ReviewState(reviewInfo: reviewInfo ?? this.reviewInfo);
  }

  @override
  List<Object?> get props =>
      [
        reviewInfo,
      ];
}
