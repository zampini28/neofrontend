import 'package:flutter/material.dart';

class ListTileComponent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final void Function(BuildContext) fn;
  const ListTileComponent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 236, 236),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).textTheme.labelSmall?.color,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Theme.of(context).textTheme.labelSmall?.color,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            return fn(context);
          },
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).textTheme.labelSmall?.color,
          ),
        ),
      ),
    );
  }
}
