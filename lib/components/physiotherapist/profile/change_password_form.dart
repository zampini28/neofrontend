import 'package:flutter/material.dart';
import 'package:physioapp/exception/profile/change_data_profile_exception.dart';
import 'package:physioapp/services/auth/auth.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _vibilityPassword = false;
  bool _visibilityConfirmPassword = false;
  bool _isLoading = false;

  Widget _defaultTextForm({required Widget textForm}) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: textForm,
    );
  }

  Future<void> _submit({required BuildContext context}) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final exception = ChangeDataProfileException();

    if (!isValid) {
      return;
    }

    try {
      setState(() => _isLoading = true);

      final result = await updateUserPassword(password: _passwordController.text);

      if (!result) {
        throw Exception('Não foi possivel alterar sua senha!');
      }

      await exception.showSucessMessageDialog(
        title: 'Sucesso',
        message: 'Senha atualizada com sucesso!',
        context: context,
      );
    } catch (error) {
      await exception.showFailedMessageDialog(
        title: 'Erro',
        message: 'Não foi possivel alterar sua senha!',
        context: context,
      );
    } finally {
      setState(() => _isLoading = true);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 2,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alterar senha',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('Mantenha sua senha segura e atualizada'),
                ],
              ),
            ),
            _defaultTextForm(
              textForm: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  label: const Text('Nova senha'),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _vibilityPassword = !_vibilityPassword);
                    },
                    child: Icon(
                      _vibilityPassword == true
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Theme.of(context).textTheme.labelLarge?.color,
                      size: 22,
                    ),
                  ),
                ),
                obscureText: _vibilityPassword == true ? false : true,
                keyboardType: TextInputType.visiblePassword,
                validator: (inputPassword) {
                  final String password = inputPassword ?? '';

                  if (password.length < 8) {
                    return 'Digite uma senha com pelo menos 8 caracteres!';
                  }

                  if (password.length > 30) {
                    return 'A senha não deve conter mais de 30 caracteres!';
                  }
                  return null;
                },
              ),
            ),
            _defaultTextForm(
              textForm: TextFormField(
                decoration: InputDecoration(
                  label: const Text('Confirmar senha'),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(
                        () => _visibilityConfirmPassword =
                            !_visibilityConfirmPassword,
                      );
                    },
                    child: Icon(
                      _visibilityConfirmPassword == true
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Theme.of(context).textTheme.labelLarge?.color,
                      size: 22,
                    ),
                  ),
                ),
                obscureText: _visibilityConfirmPassword == true ? false : true,
                keyboardType: TextInputType.visiblePassword,
                validator: (inputConfirmpassword) {
                  final String confirmPassword = inputConfirmpassword ?? '';

                  if (confirmPassword != _passwordController.text) {
                    return 'As senhas estão divergente!';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              width: 120,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
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
                        'Concluir',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
