import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListPatient extends StatelessWidget {
  final String namePatient;
  final String message;
  final DateTime dateTime;
  final int messageQuantity;
  final void Function() onTap;
  const ListPatient({
    super.key,
    required this.namePatient,
    required this.message,
    required this.dateTime,
    required this.messageQuantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime dataHora = DateTime.parse(dateTime.toIso8601String());
    final formatoHora24h = DateFormat('HH:mm');
    final String horaFormatada24h = formatoHora24h.format(dataHora);

    return SizedBox(
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          maxRadius: 30,
          backgroundColor: Colors.grey,
        ),
        title: Text(
          namePatient,
          overflow: TextOverflow.ellipsis,
        ),
        titleTextStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        subtitle: Text(
          message,
          overflow: TextOverflow.ellipsis,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.labelLarge?.color,
          fontWeight: FontWeight.normal,
        ),
        trailing: Column(
          children: [
            Text(
              horaFormatada24h,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: CircleAvatar(
                maxRadius: 10,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    messageQuantity.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
