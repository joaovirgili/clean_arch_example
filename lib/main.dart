import 'package:clean/data/adapters/i_http_adapter.dart';
import 'package:clean/data/paths.dart';
import 'package:clean/data/repositories/product_repository.dart';
import 'package:clean/domain/enitites/product.dart';
import 'package:clean/domain/repositories/i_product_repository.dart';
import 'package:clean/domain/usecases/get_products_usecase.dart';
import 'package:clean/infra/adapters/dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'domain/failures/failure.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IGetProducts getProducts;

  bool _isLoading = true;
  Failure? _error;
  late List<Product> _products;

  @override
  void initState() {
    super.initState();

    final _dio = Dio(
      BaseOptions(baseUrl: 'asd'),
    );
    final IHttpAdapter _httpAdapter = DioAdapter(dio: _dio);
    final IProductRepository _productRepository = ProductRepository(
      httpAdapter: _httpAdapter,
    );
    getProducts = GetProducts(repository: _productRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestProducts,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null) Text('Deu erro irma1'),
            if (!_isLoading && _error == null)
              Expanded(
                child: ListView(
                  children: [
                    for (final product in _products)
                      Text('id: ${product.id} | nome: ${product.nome}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _requestProducts() async {
    setState(() {
      _isLoading = true;
    });
    (await getProducts()).fold(
      (l) {
        print(l);
        _error = l;
      },
      (r) {
        _error = null;
        _products = r;
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
}
