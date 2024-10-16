import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotation/providers/product_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  Future<void> addProduct() async {
    final textTheme = Theme.of(context).textTheme;
    if (productNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        gstController.text.isEmpty ||
        unitController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Validation Error',
                  style: textTheme.displayMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Please fill in all required fields.',
                  style: textTheme.displayMedium?.copyWith(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: textTheme.displayMedium?.copyWith(fontSize: 16),
                    ),
                  )
                ],
              ));
      return;
    }

    try {
      final addProduct = ref.read(addProductProvider);
      await addProduct({
        'productname': productNameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'gst': double.parse(gstController.text),
        'unit': unitController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Success',
                  style: textTheme.displayMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Product added successfully!',
                  style: textTheme.displayMedium?.copyWith(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: textTheme.displayMedium?.copyWith(fontSize: 16),
                    ),
                  )
                ],
              ));
      clearFields();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  void clearFields() {
    productNameController.clear();
    descriptionController.clear();
    priceController.clear();
    gstController.clear();
    unitController.clear();
  }

  final List<String> products = [
    'GOLD GHAMELA -16"',
    'SILVER GHAMELA - 17\'\'',
    'GOLD GHAMELA -17"',
    'SILVER GHAMELA - 18\'\'',
    'GOLD GHAMELA -19"',
    'SILVER GHAMELA - 22\'\'',
    'CEMENT TAGARI -16"',
    'GOLD BUCKET - 05 LTR',
    'GOLD BUCKET - 07 LTR',
    'GOLD BUCKET - 10 LTR',
    'GOLD BUCKET - 13 LTR',
    'GOLD BUCKET - 16 LTR',
    'GOLD BUCKET - 19 LTR',
    'SQ BEAT PATA',
    'SUFA-BIG',
    'SUFA-SMALL',
    'UNBREAKABLE TUB --20LTRS',
    'MAHANADI TUB-50 LTRS',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Product',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name TextField
            Autocomplete<String>(
              displayStringForOption: (String option) => option,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return products.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                productNameController.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                productNameController = textEditingController;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: textTheme.displayMedium?.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: Icon(Icons.production_quantity_limits),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Colors.white, // White background for the list
                    child: Container(
                      width: MediaQuery.of(context).size.width -
                          32, // Adjust width as needed
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(
                                option,
                                style: TextStyle(
                                    color: Colors.black), // Black text color
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            // Description TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Price TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // GST TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: gstController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'GST (%)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Unit TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: unitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Add Product Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addProduct,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
