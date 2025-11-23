import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/chat/message_bubble.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MessageBubble(
        message: 'Olá gente, como que vão as coisas?',
        time: DateTime.now(),
      ),
    );
  }
}
