import 'package:flutter/material.dart';

class SearchPatient extends StatefulWidget {
  const SearchPatient({super.key});

  @override
  SearchPatientState createState() => SearchPatientState();
}

class SearchPatientState extends State<SearchPatient> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(255, 236, 236, 236),
          ),
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            decoration: InputDecoration(
              icon: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                  size: 25,
                ),
              ),
              border: InputBorder.none,
              label: Text(
                'Pesquisar Paciente',
                style: TextStyle(
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
