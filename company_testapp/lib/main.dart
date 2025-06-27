
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/company.dart';
import 'services/api_service.dart';
import 'screens/company_list_screen.dart';
import 'providers/company_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CompanyProvider(),
      child: MaterialApp(
        title: 'Gerenciador de Empresas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color.fromARGB(255,245, 245, 245),

          cardTheme: const CardThemeData(
            color: Color.fromARGB(255,200, 210, 210),
          ),

          appBarTheme: const AppBarTheme(
            elevation: 1,
            backgroundColor: const Color.fromARGB(255, 72, 207, 203),
            foregroundColor: Colors.black87,
            titleTextStyle: const TextStyle(
              color: const Color.fromARGB(255,66, 66, 66),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const CompanyListScreen(),
      ),
    );
  }
}
