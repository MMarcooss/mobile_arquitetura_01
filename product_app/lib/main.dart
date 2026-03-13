import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/pages/product_page.dart';

void main() {
  final dio = Dio();
  final datasource = ProductRemoteDatasource(dio);

  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(datasource),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductPage(),
    );
  }
}
