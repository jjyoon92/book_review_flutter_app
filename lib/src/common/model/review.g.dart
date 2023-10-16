// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      bookId: json['bookId'] as String?,
      review: json['review'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      reviewerUid: json['reviewerUid'] as String?,
      naverBookInfo: json['naverBookInfo'] == null
          ? null
          : NaverBookInfo.fromJson(
              json['naverBookInfo'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'bookId': instance.bookId,
      'review': instance.review,
      'value': instance.value,
      'reviewerUid': instance.reviewerUid,
      'naverBookInfo': instance.naverBookInfo?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
