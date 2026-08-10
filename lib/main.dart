import 'package:flutter/material.dart';
import 'package:product_7/features/ecommerce/presentation/screens/add_edit.dart';
import 'package:product_7/features/ecommerce/presentation/screens/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/ecommerce/data/datasources/product_local_data_source_impl.dart';
//import 'features/ecommerce/data/datasources/product_remote_data_source.dart';
import 'features/ecommerce/data/datasources/product_remote_data_source_impl.dart';
import 'features/ecommerce/data/repositories/product_repository_impl.dart';
import 'features/ecommerce/domain/repositories/product_repository.dart';
import 'features/ecommerce/presentation/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(repository: _initRepository(sharedPreferences)));
}

ProductRepository _initRepository(SharedPreferences sharedPreferences) {
  final remoteDataSource = ProductRemoteDataSourceImpl();
  final localDataSource = ProductLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  return ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopera',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(repository: repository),
        '/add-edit': (context) =>  AddEditScreen(repository: repository,),
        '/detail': (context) => DetailScreen(repository: repository,),
      },
    );
  }
}