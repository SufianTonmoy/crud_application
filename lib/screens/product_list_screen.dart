import 'dart:convert';

import 'package:crud_application/models/product.dart';
import 'package:crud_application/screens/add_new_product_screen.dart';
import 'package:crud_application/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _inProgress = false;
  @override
  void initState() {
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
              onPressed: () {
                getProductList();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: _inProgress
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ProductItem(
                    product: productList[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: productList.length,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddNewProductScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getProductList() async {
    productList.clear();
    _inProgress = true;
    setState(() {});
    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponce = jsonDecode(response.body);
      for (var item in jsonResponce['data']) {
        Product product = Product(
          id: item['_id'] ?? '',
          productName: item['ProductName'] ?? '',
          productCode: item['ProductCode'] ?? '',
          productImage: item['Img'] ?? '',
          unitPrice: item['UnitPrice'] ?? '',
          quantity: item['Qty'] ?? '',
          toalPrice: item['TotalPrice'] ?? '',
        );
        productList.add(product);
      }
    }
    _inProgress = false;
    setState(() {});
  }
}
