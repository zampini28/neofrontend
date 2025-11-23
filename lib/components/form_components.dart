import 'package:flutter/material.dart';

class FormComponents extends StatelessWidget {
  final Widget textForm;
  const FormComponents({super.key, required this.textForm});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color.fromARGB(255, 110, 125, 162),
          width: 1,
        ),
      ),
      child: textForm,
    );
  }
}
