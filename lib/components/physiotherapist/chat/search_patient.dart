import 'package:flutter/material.dart';

class SearchPatient extends StatefulWidget {
  const SearchPatient({super.key});

  @override
  State<SearchPatient> createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  // Atributos de controle
  final _formKey = GlobalKey<FormState>();

  // Realizar metodo de submissão de formulário
  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if(isValid == false) return;

    // Implementar com formulário
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          onChanged: (name){
            // Implementar formulário
          },
          decoration: InputDecoration(
            label: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    size: 22,
                  ),
                ),
                Text(
                  'Pesquisar...',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.name,
        ),
      ),
    );
  }
}
