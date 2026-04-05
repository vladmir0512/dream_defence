import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dream_defense/ui/screens/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DreamDefenseApp());
}

class DreamDefenseApp extends StatelessWidget {
  const DreamDefenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Defense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: const MainMenuScreen(),
    );
  }
}
