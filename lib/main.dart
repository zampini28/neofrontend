import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physioapp/core/theme/app_theme.dart';
import 'package:physioapp/utils/app_providers.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

// TODO: create an export files for pages (maybe same for services)

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown, 
  ]);

  runApp(
    DevicePreview(
      enabled: true,
      builder: (_) => const PhysioApp()
    )
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
      )
    );
  }
}
