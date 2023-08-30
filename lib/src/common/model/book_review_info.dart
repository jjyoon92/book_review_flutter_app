import 'package:book_review_app/src/common/model/naver_book_info.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_review_info.g.dart';

@JsonSerializable(explicitToJson: true)
class BookReviewInfo extends Equatable {
  final NaverBookInfo? naverBookInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? bookId;
  final double? totalCounts;
  final List<String>? reviewerUids;

  const BookReviewInfo({
    this.bookId,
    this.naverBookInfo,
    this.createdAt,
    this.updatedAt,
    this.totalCounts,
    this.reviewerUids,
  });

  factory BookReviewInfo.fromJson(Map<String, dynamic> json) => _$BookReviewInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BookReviewInfoToJson(this);

  BookReviewInfo copyWith({
    NaverBookInfo? naverBookInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? bookId,
    double? totalCounts,
    List<String>? reviewerUids,
  }) {
    return BookReviewInfo(
      naverBookInfo: naverBookInfo ?? this.naverBookInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookId: bookId ?? this.bookId,
      totalCounts: totalCounts ?? this.totalCounts,
      reviewerUids: reviewerUids ?? this.reviewerUids,
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        naverBookInfo,
        createdAt,
        updatedAt,
        totalCounts,
        reviewerUids,
      ];
}
