import 'package:flutter/material.dart';
import 'features/ecommerce/presentation/screens/home.dart';
import 'features/ecommerce/presentation/screens/add_edit.dart';
import 'features/ecommerce/presentation/screens/detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-edit': (context) => const AddEditScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}