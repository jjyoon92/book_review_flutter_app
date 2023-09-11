import 'package:book_review_app/src/common/model/naver_book_info.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable(explicitToJson: true)
class Review extends Equatable {
  final String? bookId;
  final String? review;
  final double? value;
  final String? reviewerUid;
  final NaverBookInfo? naverBookInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Review({
    this.bookId,
    this.review,
    this.value,
    this.reviewerUid,
    this.naverBookInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  Review copyWith({
    String? bookId,
    String? review,
    double? value,
    String? reviewerUid,
    NaverBookInfo? naverBookInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      bookId: bookId ?? this.bookId,
      review: review ?? this.review,
      value: value ?? this.value,
      reviewerUid: reviewerUid ?? this.reviewerUid,
      naverBookInfo: naverBookInfo ?? this.naverBookInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [
        bookId,
        review,
        value,
        reviewerUid,
        naverBookInfo,
        createdAt,
        updatedAt,
      ];
}
