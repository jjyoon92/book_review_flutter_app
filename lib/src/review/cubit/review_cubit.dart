import 'package:bloc/bloc.dart';
import 'package:book_review_app/src/common/model/naver_book_info.dart';
import 'package:book_review_app/src/common/model/review.dart';
import 'package:equatable/equatable.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(String uid, NaverBookInfo naverBookInfo)
      : super(ReviewState(
            reviewInfo:
                Review(reviewerUid: uid, naverBookInfo: naverBookInfo),));

  changeValue(double value) {
    emit(state.copyWith(reviewInfo: state.reviewInfo!.copyWith(value: value)));
  }

  changeReview(String review) {
    emit(
        state.copyWith(reviewInfo: state.reviewInfo!.copyWith(review: review)));
  }

  save() async {
    print(state.reviewInfo);
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
  List<Object?> get props => [
        reviewInfo,
      ];
}
