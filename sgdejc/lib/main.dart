import 'package:flutter/material.dart';
import 'package:sgdejc/Telas/Login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sgdejc/Telas/home_page.dart';
import 'package:sgdejc/componentes/theme.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que a aplicação foi carregada.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EJC Gerenciamento',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      
      home: LoginPage(),
    );
  }
}
