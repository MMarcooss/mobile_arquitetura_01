import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import './presentation/pages/login_page.dart';
import './presentation/providers/favorites_provider.dart';
import './data/datasources/product_remote_datasource.dart';
import './data/datasources/productcachedatasource.dart';
import './data/repositories/product_repositoryimpl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(
        ProductRepositoryImpl(
          ProductRemoteDatasource(Dio()),
          ProductCacheDatasource(),
        ),
      ),
      child: MaterialApp(
        title: 'Projeto Produtos com Autenticação',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
        home: const LoginPage(),
      ),
    );
  }
}
