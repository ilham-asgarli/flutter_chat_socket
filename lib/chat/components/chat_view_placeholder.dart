import 'package:flutter/material.dart';

class ChatViewPlaceholder extends StatelessWidget {
  const ChatViewPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
