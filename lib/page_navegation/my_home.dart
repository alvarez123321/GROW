import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(0, 192, 41, 41),
        child: const Center(
          child: Text('Página de de home '),
        ),
      ),
    );
  }
}
