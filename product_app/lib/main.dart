import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/productcachedatasource.dart';
import 'data/repositories/product_repositoryimpl.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/pages/home_page.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      validateStatus: (_) => true,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );
  final remoteDatasource = ProductRemoteDatasource(dio);
  final cacheDatasource = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(remoteDatasource, cacheDatasource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A148C)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
