import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:physioapp/core/theme/app_theme.dart';
import 'package:physioapp/pwa/pwa_install.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/app_providers.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:physioapp/web_only/js_bridge.dart';
import 'package:provider/provider.dart';

// TODO: create an export files for pages (maybe same for services)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('pt_BR', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // TODO: REMOVE THIS
  logout();

  runApp(
    kDebugMode || (kIsWeb && kReleaseMode && isDevicePreview())
        ? DevicePreview(enabled: true, builder: (_) => const PhysioApp())
        : (kIsWeb && kReleaseMode && !isRunningAsPWA())
            // ? const InstallPwa()
            ? const PhysioApp()
            : const PhysioApp()
  );
}

class PhysioApp extends StatelessWidget {
  @override
  const PhysioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.global,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.initial,
        routes: AppRoutes.map,
      ),
    );
  }
}
