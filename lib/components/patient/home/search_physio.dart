import 'package:flutter/material.dart';

class SearchPhysio extends StatefulWidget {
  const SearchPhysio({super.key});

  @override
  SearchPhysioState createState() => SearchPhysioState();
}

class SearchPhysioState extends State<SearchPhysio> {
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
                'Pesquisar Fisioterapeuta',
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
