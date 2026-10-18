import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/ui/ios.dart';
import 'src/ui/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CfManagerApp()));
}

class CfManagerApp extends StatelessWidget {
  const CfManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudflare 管理器',
      debugShowCheckedModeBanner: false,
      theme: IosTheme.light(),
      darkTheme: IosTheme.dark(),
      themeMode: ThemeMode.system,
      builder: (context, child) => GlassBackground(child: child!),
      home: const LoginGate(),
    );
  }
}
