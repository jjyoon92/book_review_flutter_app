import 'package:book_review_app/src/common/components/app_font.dart';
import 'package:book_review_app/src/common/components/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: context.pop,
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset('assets/svg/icons/icon_arrow_back.svg'),
            ),
          ),
          title: const AppFont(
            '책 검색',
            size: 18,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            children: [InputWidget(
              onSearch: (searchKey) {

              },
            )],
          ),
        ));
  }
}
