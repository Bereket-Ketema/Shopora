import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/detail_screen.dart';
import 'models/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle all routes with custom transitions
        switch (settings.name) {
          case '/':
            return CustomPageRoute(
              child: const HomeScreen(),
              settings: settings,
            );
          case '/add-edit':
            final product = settings.arguments as Product?;
            return CustomPageRoute(
              child: AddEditScreen(product: product),
              settings: settings,
            );
          case '/detail':
            final product = settings.arguments as Product;
            return CustomPageRoute(
              child: DetailScreen(product: product),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}

// 🎨 Custom Page Route with Smooth Animation
class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({
    required this.child,
    required super.settings,
  }) : super(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Slide from bottom animation
    const begin = Offset(0.0, 0.3);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    // Fade animation
    var fadeAnimation = animation.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: offsetAnimation,
        child: child,
      ),
    );
  }
}