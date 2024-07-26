import 'package:flutter/material.dart';
import 'package:flutter_template/services/theme_provider.dart';
import 'package:flutter_template/widgets/dark_theme.dart';
import 'package:flutter_template/widgets/light_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class DefaultFirebaseOptions {
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: LightTheme.themeData,
          darkTheme: DarkTheme.themeData,
          home: const Placeholder()
        );
      })
    );
  }
}

