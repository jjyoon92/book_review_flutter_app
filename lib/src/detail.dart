import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Appbar'),
      ),
      body: const Center(
        child: Text(
          'Detail',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
