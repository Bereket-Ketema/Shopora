import 'package:flutter/material.dart';
import 'package:product_7/screens/add_edit.dart';
import 'package:product_7/screens/home.dart';
import 'package:product_7/screens/detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/add-edit': (context) => const AddEdit(),
        '/detail': (context) => const Detail(),
      },
    );
  }
}