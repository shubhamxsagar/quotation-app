import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quotation/providers/auth_provider.dart';
import 'package:quotation/providers/product_provider.dart';
import 'package:quotation/providers/quotation_provider.dart';
import 'package:intl/intl.dart';
import 'package:quotation/routes/my_app_route.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';

class MakeQuotationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotationDate = ref.watch(quotationDateProvider.notifier).state;
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final selectedProducts = ref.watch(selectedProductsProvider);
    final otherCharges = ref.read(otherChargesProvider);
    final quotationSummary =
        calculateQuotationSummary(selectedProducts, otherCharges);

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Make Quotation',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quotation Date and Number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quotation Date: ${DateFormat('dd-MM-yyyy').format(quotationDate)}',
                    style: textTheme.displayMedium?.copyWith(fontSize: 14),
                  ),
                  Text(
                    'Quotation No: -',
                    style: textTheme.displayMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Bill To Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BILL TO',
                    style: textTheme.displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.black, // Background color for the plus icon
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    onPressed: () {
                      context.pushNamed(RouteConstants.customer);
                    },
                  ),
                ],
              ),
              selectedCustomer != null
                  ? Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${selectedCustomer['name']}',
                                style: textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${selectedCustomer['compname']}',
                                style: textTheme.displayMedium
                                    ?.copyWith(fontSize: 14),
                              ),
                              Text(
                                '${selectedCustomer['mobile']}',
                                style: textTheme.displayMedium
                                    ?.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref
                                  .watch(selectedCustomerProvider.notifier)
                                  .state = null;

                              // Handle delete customer
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'No customer selected',
                        style: textTheme.displayMedium
                            ?.copyWith(color: Colors.grey, fontSize: 14),
                      ),
                    ),

              SizedBox(height: 16),

              // Products Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PRODUCTS',
                    style: textTheme.displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.black, // Background color for the plus icon
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    onPressed: () {
                      context.pushNamed(RouteConstants.product);
                    },
                  ),
                ],
              ),

              // Scrollable list of selected products
              selectedProducts.isNotEmpty
                  ? Column(
                      children: selectedProducts
                          .map((product) => ProductCard(product: product))
                          .toList(),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'No products selected',
                        style: textTheme.displayMedium
                            ?.copyWith(color: Colors.grey, fontSize: 14),
                      ),
                    ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Other Charges',
                    style: textTheme.displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.black, // Background color for the plus icon
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    onPressed: () {
                      showOtherChargesDialog(context, ref);
                      // Handle other charges
                    },
                  ),
                ],
              ),

              // List of other charges
              buildOtherChargesList(context, ref),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TERMS and CONDITIONS',
                    style: textTheme.displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.black, // Background color for the plus icon
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    onPressed: () {
                      // Handle terms and conditions
                      context.pushNamed(RouteConstants.termsConditions);
                    },
                  ),
                ],
              ),

              // Generate Quotation Button and Total GST/Amount Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total GST and Amount Due
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total GST',
                          style: textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rs${quotationSummary['totalGst']}',
                          style: textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount Due',
                          style: textTheme.displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rs${quotationSummary['totalAmount']}',
                          style: textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    // Generate Button
                    ElevatedButton(
                      onPressed: () async {
                        final pdfFile = await generateQuotationPDF(
                          quotationDate,
                          selectedCustomer,
                          selectedProducts,
                          quotationSummary,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PDFViewerScreen(pdfFile: pdfFile),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Generate',
                        style: textTheme.displayMedium
                            ?.copyWith(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showOtherChargesDialog(BuildContext context, WidgetRef ref) {
    TextEditingController chargeNameController = TextEditingController();
    TextEditingController chargeAmountController = TextEditingController();
    TextEditingController taxController = TextEditingController();
    final textTheme = Theme.of(context).textTheme;

    bool isTaxable = false;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Other Charge Info',
                      style: textTheme.displayMedium
                          ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // Charge Name TextField
                    TextField(
                      style: textTheme.displayMedium?.copyWith(fontSize: 16),
                      controller: chargeNameController,
                      decoration: InputDecoration(
                        labelText: 'Other Charge Label',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Charge Amount TextField
                    TextField(
                      style: textTheme.displayMedium?.copyWith(fontSize: 16),
                      controller: chargeAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Other Charge Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Checkbox for Is Taxable
                    Row(
                      children: [
                        Checkbox(
                          value: isTaxable,
                          onChanged: (bool? value) {
                            setState(() {
                              isTaxable = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'Is Taxable?',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),

                    // Conditionally show Tax TextField
                    if (isTaxable)
                      TextField(
                        style: textTheme.displayMedium?.copyWith(fontSize: 16),
                        controller: taxController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'TAX (IN %)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    SizedBox(height: 16),

                    // Save Button
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          final chargeName = chargeNameController.text;
                          final chargeAmount =
                              double.tryParse(chargeAmountController.text) ??
                                  0.0;
                          final taxPercentage = isTaxable
                              ? double.tryParse(taxController.text) ?? 0.0
                              : 0.0;

                          if (chargeName.isNotEmpty && chargeAmount > 0) {
                            // Use ref.read to update the provider state
                            final otherCharges =
                                ref.read(otherChargesProvider.notifier).state;

                            ref.read(otherChargesProvider.notifier).state = [
                              ...otherCharges, // Spread existing list
                              {
                                'name': chargeName,
                                'amount': chargeAmount,
                                'isTaxable': isTaxable,
                                'taxPercentage': taxPercentage,
                              }
                            ];

                            Navigator.pop(context); // Close the bottom sheet
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget buildOtherChargesList(BuildContext context, WidgetRef ref) {
  final otherCharges = ref.watch(otherChargesProvider);
  final textTheme = Theme.of(context).textTheme;

  if (otherCharges.isEmpty) {
    return Text('No other charges added.');
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: otherCharges.asMap().entries.map((entry) {
      int index = entry.key;
      var charge = entry.value;

      final name = charge['name'] as String;
      final amount = charge['amount'] as double;
      final isTaxable = charge['isTaxable'] as bool;
      final taxPercentage = charge['taxPercentage'] as double;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: textTheme.displayMedium?.copyWith(fontSize: 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Amount: \$${amount.toStringAsFixed(2)}',
                    style: textTheme.displayMedium?.copyWith(fontSize: 16),
                  ),
                  if (isTaxable)
                    Text(
                      'Tax: ${taxPercentage}%',
                      style: textTheme.displayMedium?.copyWith(fontSize: 16),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                final currentCharges =
                    ref.watch(otherChargesProvider.notifier).state;

                // Ensure the index is within range
                if (index >= 0 && index < currentCharges.length) {
                  // Create a copy of the list to avoid modifying the original state directly
                  final updatedCharges =
                      List<Map<String, dynamic>>.from(currentCharges);

                  // Remove the charge at the given index
                  updatedCharges.removeAt(index);

                  // Update the state with the modified list
                  ref.watch(otherChargesProvider.notifier).state =
                      updatedCharges;
                }
              },
            ),
          ],
        ),
      );
    }).toList(),
  );
}

Map<String, String> calculateQuotationSummary(
    List<Map<String, dynamic>> selectedProducts,
    List<Map<String, dynamic>> otherCharges) {
  double subTotal = 0.0; // Total amount for products before taxes
  double totalGst = 0.0; // Total GST for all products and taxable charges
  double totalAmount = 0.0; // Final total amount (including GST and charges)

  // Calculate subtotal and total GST for products
  for (var product in selectedProducts) {
    final double price = double.tryParse(product['price'].toString()) ?? 0.0;
    final int unit = int.tryParse(product['unit'].toString()) ?? 0;
    final double totalProductAmount = price * unit;

    final double gstRate = double.tryParse(product['gst'].toString()) ?? 0.0;
    final double gstAmount = totalProductAmount * (gstRate / 100);

    subTotal += totalProductAmount;
    totalGst += gstAmount;
  }

  // Calculate other charges and their GST (if applicable)
  double otherChargesTotal = 0.0;
  for (var charge in otherCharges) {
    final String name = charge['name'] ?? 'Other Charge';
    final double amount = double.tryParse(charge['amount'].toString()) ?? 0.0;
    final bool isTaxable = charge['isTaxable'] ?? false;
    final double taxPercentage = isTaxable
        ? (double.tryParse(charge['taxPercentage'].toString()) ?? 0.0)
        : 0.0;

    final double chargeGst = amount * (taxPercentage / 100);

    otherChargesTotal += amount;
    if (isTaxable) {
      totalGst += chargeGst; // Add GST from the charge if it's taxable
    }
  }

  // Final total amount including products, other charges, and GST
  totalAmount = subTotal + otherChargesTotal + totalGst;

  // Return values formatted to one decimal place
  return {
    'subTotal': subTotal.toStringAsFixed(1), // Total before taxes and charges
    'totalGst': totalGst
        .toStringAsFixed(1), // Total GST for products and taxable charges
    'totalAmount': totalAmount
        .toStringAsFixed(1), // Final total amount (including GST and charges)
    'otherChargesTotal':
        otherChargesTotal.toStringAsFixed(1), // Total of other charges
  };
}

// Widget to display individual products
class ProductCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  ProductCard({required this.product});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double price =
        double.tryParse(widget.product['price'].toString()) ?? 0.0;
    final int unit = int.tryParse(widget.product['unit'].toString()) ?? 0;
    final double totalAmount = price * unit;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product['productname'],
                style: textTheme.displayMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  final products =
                      ref.watch(selectedProductsProvider.notifier).state;
                  products.remove(widget.product);
                  ref.watch(selectedProductsProvider.notifier).state = [
                    ...products
                  ];
                  // Handle delete product
                },
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Amount:} : Rs${widget.product['price']}',
            style: textTheme.displayMedium?.copyWith(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'GST : ${widget.product['gst']}%',
            style: textTheme.displayMedium?.copyWith(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Total amount: Rs$totalAmount',
            style: textTheme.displayMedium?.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

Future<File> generateQuotationPDF(
  DateTime quotationDate,
  Map<String, dynamic>? selectedCustomer,
  List<Map<String, dynamic>> selectedProducts,
  Map<String, dynamic> quotationSummary,
) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Company header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${selectedCustomer!['name']}',
                        style: pw.TextStyle(fontSize: 24)),
                    pw.SizedBox(height: 4),
                    pw.Text('Address Line 1'),
                    pw.Text('Phone: 6888686868'),
                    pw.Text('Email: shubhansagar3010@gmail.com'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Quotation # Quote-3'),
                    pw.Text(
                        'Date: ${DateFormat('dd/MM/yyyy').format(quotationDate)}'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // Customer Information
            pw.Text('To,', style: pw.TextStyle(fontSize: 16)),
            pw.Text('${selectedCustomer!['name']}'),
            pw.Text('${selectedCustomer['compname']}'),
            pw.Text('Phone: ${selectedCustomer['mobile']}'),
            pw.Text('Email: ${selectedCustomer['email']}'),
            pw.SizedBox(height: 16),

            // Itemized table
            pw.Table.fromTextArray(
              headers: ['Description', 'Qty', 'Price', 'Tax', 'Total'],
              data: selectedProducts.map((product) {
                // Convert price and unit to num (double or int) before multiplication
                final double price =
                    double.tryParse(product['price'].toString()) ?? 0.0;
                final int unit = int.tryParse(product['unit'].toString()) ?? 0;
                final double totalAmount = price * unit;

                return [
                  product['productname'],
                  unit.toString(),
                  'Rs${price.toStringAsFixed(2)}', // Format price with 2 decimal places
                  '${product['gst']}%',
                  'Rs${totalAmount.toStringAsFixed(2)}', // Format totalAmount with 2 decimal places
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 16),

            // Total Amount
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Sub Total: Rs${quotationSummary['subTotal']}'),
                    pw.Text('Tax: Rs${quotationSummary['totalGst']}'),
                    pw.Text(
                      'Grand Total: Rs${quotationSummary['totalAmount']}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // Signature Section
            pw.Text('For, ${selectedCustomer!['name']}',
                style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 24),
            pw.Text('Authorized Signature'),
          ],
        );
      },
    ),
  );

  final outputDir = await getApplicationDocumentsDirectory();
  final pdfFile = File('${outputDir.path}/quotation.pdf');
  await pdfFile.writeAsBytes(await pdf.save());
  return pdfFile;
}

class PDFViewerScreen extends ConsumerWidget {
  final File pdfFile;

  PDFViewerScreen({required this.pdfFile});

  Future<void> _uploadPDF(BuildContext context, WidgetRef ref) async {
    try {
      final firestore = ref.read(firebaseFirestoreProvider);
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final user = ref.watch(authStateProvider).value;

      print('Uploading PDF...');
      print('File name: $fileName');

      // Upload PDF to Firebase Storage
      final uploadTask =
          storageRef.child('pdfs/$fileName.pdf').putFile(pdfFile);
      print('uploadTask $uploadTask');

      // Monitor upload progress (optional)
      try {
        uploadTask.snapshotEvents.listen((snapshot) {
          print(
              'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        });
      } catch (e) {
        print('Error: $e');
      }
      // uploadTask.snapshotEvents.listen((snapshot) {
      //   print(
      //       'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      // });

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('downloadUrl $downloadUrl');
      print('user uid ${user?.uid}');

      // Save PDF URL to Firestore
      await firestore
          .collection('users')
          .doc(user?.uid)
          .collection('uploaded_pdfs')
          .add({
        'fileName': '$fileName.pdf',
        'url': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      print('PDF uploaded successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF uploaded successfully!')),
      );
    } catch (e) {
      print('Failed to upload PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotation PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () => _uploadPDF(context, ref),
          ),
        ],
      ),
      body: SfPdfViewer.file(pdfFile),
    );
  }
}
