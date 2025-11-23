import 'package:flutter/material.dart';
import 'package:physioapp/exception/profile/change_data_profile_exception.dart';
import 'package:physioapp/services/auth/patient/auth_patient_service.dart';

class ChangeNameForm extends StatefulWidget {
  final void Function() refreshPage;
  const ChangeNameForm({super.key, required this.refreshPage});

  @override
  State<ChangeNameForm> createState() => _ChangeNameFormState();
}

class _ChangeNameFormState extends State<ChangeNameForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Widget _defaultTextForm({required Widget textForm}) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: textForm,
    );
  }

  Future<void> _submit({required BuildContext context}) async {
    final currentUser = AuthPatientService();
    final exception = ChangeDataProfileException();
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    try {
      setState(() => _isLoading = true);

      await currentUser.updateUser(
        currentUser: currentUser.currentPatientUser,
        name: _nameController.text,
      );

      await exception.showSucessMessageDialog(
        title: 'Sucesso',
        message: 'Nome atualizado com sucesso!',
        context: context,
      );
    } catch (error) {
      await exception.showFailedMessageDialog(
        title: 'Erro',
        message: 'Não foi possivel atualizar o nome! $error',
        context: context,
      );
    } finally {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();

      widget.refreshPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alterar Nome',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('Alterar nome cadastrado'),
                ],
              ),
            ),
            _defaultTextForm(
              textForm: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text('Nome'),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.name,
                validator: (inputName) {
                  final String name = inputName ?? '';

                  if (name.trim().length < 6) {
                    return 'Digite seu nome completo';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              height: 40,
              width: 130,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.tertiary,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () => _submit(context: context),
                      child: const Text(
                        'Atualizar',
                        style: TextStyle(
                          color: Colors.white,
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
