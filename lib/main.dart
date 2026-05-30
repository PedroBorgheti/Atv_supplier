import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/supplier_list_page.dart';

void main() {
  runApp(const SupplierApp());
}

class SupplierApp extends StatefulWidget {
  const SupplierApp({super.key});

  @override
  State<SupplierApp> createState() => _SupplierAppState();
}

class _SupplierAppState extends State<SupplierApp> {
  bool _isLoggedIn = false;
  ThemeMode _themeMode = ThemeMode.light;

  bool get _isDarkMode => _themeMode == ThemeMode.dark;

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _isDarkMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Fornecedores',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        cardTheme: const CardThemeData(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF60A5FA),
          brightness: Brightness.dark,
        ),
        cardTheme: const CardThemeData(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: _isLoggedIn
          ? SupplierListPage(
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
              onLogout: _logout,
            )
          : LoginPage(
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
              onLogin: _login,
            ),
    );
  }
}
