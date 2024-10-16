import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quotation/product/add_product.dart';
import 'package:quotation/providers/product_provider.dart';
import 'package:quotation/providers/quotation_provider.dart';
import 'package:quotation/routes/my_app_route.dart';

class ProductScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListAsyncValue = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'SearchProduct',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Customer List UI exactly the same
            Expanded(
              child: productListAsyncValue.when(
                data: (customers) {
                  if (customers.isEmpty) {
                    return Center(child: Text("No Products added yet."));
                  }
                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Text(
                            customer['productname'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(customer['gst'].toString()),
                              SizedBox(height: 4),
                              Text(
                                customer['price'].toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            ref.read(selectedProductsProvider.notifier).state =
                                [
                              ...ref.read(selectedProductsProvider),
                              customer,
                            ];

                            // Navigate back to MakeQuotationScreen
                            context.pop();
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(RouteConstants.addProduct);
        },
        backgroundColor: Colors.black,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text('Add Product',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
