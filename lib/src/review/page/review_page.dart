import 'package:book_review_app/src/common/components/app_divider.dart';
import 'package:book_review_app/src/common/components/app_font.dart';
import 'package:book_review_app/src/common/components/btn.dart';
import 'package:book_review_app/src/common/components/review_slider_bar.dart';
import 'package:book_review_app/src/common/model/naver_book_info.dart';
import 'package:book_review_app/src/review/cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends StatelessWidget {
  final NaverBookInfo bookInfo;

  const ReviewPage(this.bookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset('assets/svg/icons/icon_arrow_back.svg'),
          ),
        ),
        title: const AppFont('리뷰 작성', size: 18),
      ),
      body: Column(
        children: [
          _HeaderBookInfo(bookInfo),
          const AppDivider(),
          Expanded(
              child: BlocBuilder<ReviewCubit, ReviewState>(
                  // 기존에 작성된 리뷰를 수정하려할때 텍스트에디터의 첫 위치로 가는 현상 해결.
                  buildWhen: (previous, current) =>
                      current.isEditMode != previous.isEditMode,
                  builder: (context, state) {
                    return _ReviewBox(
                      initReview: state.reviewInfo?.review,
                    );
                  })),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Btn(
          onTap: context.read<ReviewCubit>().save,
          // context.push('/review', extra: bookInfo);
          text: '저장',
        ),
      ),
    );
  }
}

class _HeaderBookInfo extends StatelessWidget {
  final NaverBookInfo bookInfo;

  const _HeaderBookInfo(this.bookInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: 71,
              height: 106,
              child: Image.network(
                bookInfo.image ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppFont(
                  bookInfo.title ?? '',
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                AppFont(
                  bookInfo.author?.replaceAll('^', ' ') ?? '',
                  size: 12,
                  color: const Color(0xff878787),
                ),
                const SizedBox(height: 10),
                BlocBuilder<ReviewCubit, ReviewState>(
                    builder: (context, state) {
                  return ReviewSliderBar(
                    initValue: state.reviewInfo?.value ?? 0,
                    onChange: context.read<ReviewCubit>().changeValue,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewBox extends StatefulWidget {
  final String? initReview;

  const _ReviewBox({super.key, this.initReview});

  @override
  State<_ReviewBox> createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<_ReviewBox> {
  TextEditingController editingController = TextEditingController();

  @override
  void didUpdateWidget(covariant _ReviewBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (editingController.text != widget.initReview) {
    //   editingController.text = widget.initReview ?? '';
    // }
    editingController.text = widget.initReview ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      autofocus: true,
      maxLines: null,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: '리뷰를 입력해주세요.',
        contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
        hintStyle: TextStyle(
          color: Color(0xff585858),
        ),
      ),
      onChanged: context.read<ReviewCubit>().changeReview,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
