import 'package:demo_page/desktop.dart';
import 'package:demo_page/backup/main_screen.dart';
import 'package:demo_page/homepage.dart';
import 'package:demo_page/responsive_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Project.dart';
import 'firebase_options.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MaterialApp(
        title: 'Your App Title',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
