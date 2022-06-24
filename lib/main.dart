import 'package:flutter/material.dart';
import 'package:flutter_number_game/presentation/screens/number_screen.dart';
import 'package:flutter_number_game/service_locator.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sl.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Game',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.cyanAccent,
        ),
      ),
      home: const NumberScreen(),
    );
  }
}
