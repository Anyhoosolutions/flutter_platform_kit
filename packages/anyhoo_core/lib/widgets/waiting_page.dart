import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
