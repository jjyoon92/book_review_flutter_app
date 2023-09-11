import 'package:bloc/bloc.dart';
import 'package:book_review_app/src/common/enum/common_state_status.dart';
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
          naverBookInfo: naverBookInfo))) {
    _loadReviewInfo();
  }

  _loadReviewInfo() async {
    var reviewInfo = await _reviewRepository.loadReviewInfo(
        state.reviewInfo!.bookId!, state.reviewInfo!.reviewerUid!);

    emit(state.copyWith(
      isEditMode: reviewInfo != null, // 리뷰(reviewInfo)가 있을 경우 (not null) 수정 모드.
      reviewInfo: reviewInfo,
      beforeValue: reviewInfo?.value,
    ));

    // if (reviewInfo == null) {
    //   // 리뷰한 적 없는 책
    //   emit(state.copyWith(isEditMode: false));
    // } else {
    //   // 리뷰한 적 있는 책
    //   emit(state.copyWith(isEditMode: true));
    // }
  }

  changeValue(double value) {
    emit(state.copyWith(reviewInfo: state.reviewInfo!.copyWith(value: value)));
  }

  changeReview(String review) {
    print("리뷰 변화 감지");
    emit(
        state.copyWith(reviewInfo: state.reviewInfo!.copyWith(review: review)));
    print("리뷰 내용 : ${state.reviewInfo!.review}");
  }

  Future<void> insert() async {
    var now = DateTime.now();
    emit(state.copyWith(
        reviewInfo:
        state.reviewInfo!.copyWith(createdAt: now, updatedAt: now)));
    await _reviewRepository.createReview(state.reviewInfo!);

    var bookId = state.reviewInfo!.bookId!;
    var bookReviewInfo =
    await _bookReviewInfoRepository.loadBookReviewInfo(bookId);

    if (bookReviewInfo == null) {
      // bookId에 리뷰가 없으면 생성. insert
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
      // bookId에 리뷰가 있으면 수정. update
      bookReviewInfo.reviewerUids!.add(state.reviewInfo!.reviewerUid!);
      bookReviewInfo = bookReviewInfo.copyWith(
        totalCounts: bookReviewInfo.totalCounts! -
            (state.beforeValue ?? 0) +
            state.reviewInfo!.value!,
        reviewerUids: bookReviewInfo.reviewerUids!.toSet().toList(),
        // 수정 작업시 중복된 uid가 있을 시 중복이 발생하지 않도록.
        updatedAt: DateTime.now(),
      );
      _bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }
  }

  Future<void> update() async {
    var updateData = state.reviewInfo!.copyWith(updatedAt: DateTime.now());
    await _reviewRepository.updateReview(updateData);
    var bookReviewInfo =
    await _bookReviewInfoRepository.loadBookReviewInfo(updateData.bookId!);

    if (bookReviewInfo != null) {
      bookReviewInfo = bookReviewInfo.copyWith(
        updatedAt: DateTime.now(),
        totalCounts: bookReviewInfo.totalCounts! -
            (state.beforeValue ?? 0) +
            state.reviewInfo!.value!,
      );
      await _bookReviewInfoRepository.updateBookReviewInfo(bookReviewInfo);
    }
  }

  save() async {
    emit(state.copyWith(status: CommonStateStatus.loading));
    var message = '';
    if (state.isEditMode!) {
      // edit
      await update();
      message = '리뷰가 수정 되었습니다.';
    } else {
      // insert
      await insert();
      message = '리뷰가 등록 되었습니다.';
    }
    emit(state.copyWith(status: CommonStateStatus.loaded, message: message));
  }
}

class ReviewState extends Equatable {
  final CommonStateStatus status;
  final Review? reviewInfo;
  final bool? isEditMode;
  final double? beforeValue;
  final String? message;

  const ReviewState({
    this.reviewInfo,
    this.isEditMode,
    this.beforeValue,
    this.status = CommonStateStatus.init,
    this.message,
  });

  ReviewState copyWith({
    Review? reviewInfo,
    bool? isEditMode,
    double? beforeValue,
    CommonStateStatus? status,
    String? message,
  }) {
    return ReviewState(
      reviewInfo: reviewInfo ?? this.reviewInfo,
      isEditMode: isEditMode ?? this.isEditMode,
      beforeValue: beforeValue ?? this.beforeValue,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [
        reviewInfo,
        isEditMode,
        beforeValue,
        status,
        message,
      ];
}
