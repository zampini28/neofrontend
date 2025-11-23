import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final DateTime time;
  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime dataHora = DateTime.parse(time.toIso8601String());
    final formatoHora24h = DateFormat('HH:mm');
    final String horaFormatada24h = formatoHora24h.format(dataHora);
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Positioned(
          bottom: 15,
          right: 40,
          child: Text(
            horaFormatada24h,
            style: TextStyle(
              color: Theme.of(context).textTheme.labelLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
