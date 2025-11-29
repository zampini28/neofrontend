import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:physioapp/core/theme/app_theme.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/utils/app_providers.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:physioapp/utils/javascript.dart';
import 'package:physioapp/pwa/pwa_install.dart';
import 'package:provider/provider.dart';

// TODO: create an export files for pages (maybe same for services)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown, 
  ]);

  // TODO: REMOVE THIS
  logout();

  final bool device_preview = isDevicePreview();
  print("device preview: $device_preview");

  final bool running_pwa = isRunningAsPWA();
  print("running as pwa: $running_pwa");

  if (kIsWeb && kReleaseMode && !isRunningAsPWA()) {
    runApp(const InstallPwa());
    return;
  }

  if (kDebugMode) {
    runApp(
      DevicePreview(
        enabled: true,
        builder: (_) => const PhysioApp(),
      ),
    );
    return;
  }

  if (kReleaseMode && kIsWeb && isDevicePreview()) {
    runApp(
      DevicePreview(
        enabled: true,
        builder: (_) => const PhysioApp(),
      ),
    );
    return;
  }

  
  runApp(const PhysioApp());
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
      )
    );
  }
}
