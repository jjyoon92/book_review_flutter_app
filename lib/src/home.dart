import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Appbar'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.go('/detail');
          },
          child: const Text('Home'),
        ),
      ),
    );
  }
}
