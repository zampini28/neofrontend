import 'package:flutter/material.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/auth/auth_form.dart';

class PhysioOrPatientPage extends StatefulWidget {
  const PhysioOrPatientPage({super.key});

  @override
  PhysioOrPatientPageState createState() => PhysioOrPatientPageState();
}

class PhysioOrPatientPageState extends State<PhysioOrPatientPage> {

  bool _isPhysioSelected = false;

  void _navigateToAuth() {
    final route = _isPhysioSelected ? AppRoutes.authPhysioPage : AppRoutes.authPatientPage;
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    logout();
    AuthFormData().reset();

    debugPrint('--- physioapp ---');
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              const Color.fromARGB(127, 255, 255, 255),
              const Color.fromARGB(127, 255, 255, 255),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(flex: 1),

                        // logo
                        Image.asset(
                          'assets/images/logotipo.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),

                        const Spacer(flex: 1),

                        // text
                        Text(
                          'Bem Vindo!',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),

                        const SizedBox(height: 16),

                        // description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Bem vindo a plataforma PhysioApp, '
                            'facilite e agilize suas consultas, '
                            'seja como paciente ou fisioterapeuta.',
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const Spacer(flex: 2),

                        // toggle switch
                        RoleToggleSwitch(
                            isPhysioSelected: _isPhysioSelected,
                            onChanged: (val) => setState(() => _isPhysioSelected = val),
                          ),
                        const Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: TextButton(
        onPressed: _navigateToAuth,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Próximo',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19,
                fontStyle: Theme.of(context).textTheme.labelLarge?.fontStyle,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}


class RoleToggleSwitch extends StatelessWidget {
  final bool isPhysioSelected;
  final ValueChanged<bool> onChanged;
  final double width;

  const RoleToggleSwitch({
    super.key,
    required this.isPhysioSelected,
    required this.onChanged,
    this.width = 310,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 56;
    const double padding = 4;
    final double toggleWidth = (width / 2) - padding;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left: isPhysioSelected ? toggleWidth : 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: toggleWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildLabel(context, 'Paciente', !isPhysioSelected),
              _buildLabel(context, 'Fisioterapeuta', isPhysioSelected),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onChanged(text == 'Fisioterapeuta'),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 16,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
