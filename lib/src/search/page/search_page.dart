import 'package:book_review_app/src/common/components/app_font.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppFont(
          '검색',
        ),
      ),
    );
  }
}
