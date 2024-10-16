import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quotation/providers/auth_provider.dart';

// FirebaseFirestore instance provider (already defined in your app)
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Product list provider
final productListProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return ref.watch(firebaseFirestoreProvider)
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                'productname': doc['productname'],
                'description': doc['description'],
                'price': doc['price'],
                'gst': doc['gst'],
                'unit': doc['unit'],
                'createdAt': doc['createdAt'],
              };
            }).toList());
  } else {
    return const Stream.empty();
  }
});

// Function to add a product
final addProductProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final user = ref.watch(authStateProvider).value;

  Future<void> addProduct(Map<String, dynamic> productData) async {
    if (user != null) {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('products')
          .add(productData);
    }
  }

  return addProduct;
});

Map<String, dynamic> calculateQuotationSummary(
    List<Map<String, dynamic>> selectedProducts) {
  double subTotal = 0;
  double totalGst = 0;

  for (var product in selectedProducts) {
    final double price = double.tryParse(product['price'].toString()) ?? 0.0;
    final int unit = int.tryParse(product['unit'].toString()) ?? 1;
    final double totalAmount = price * unit;
    final double gstRate = double.tryParse(product['gst'].toString()) ?? 0.0;
    final double gstAmount = totalAmount * (gstRate / 100);

    subTotal += totalAmount;
    totalGst += gstAmount;
  }

  double totalAmount = subTotal + totalGst;

  return {
    'subTotal': subTotal,
    'totalGst': totalGst,
    'totalAmount': totalAmount,
  };
}

