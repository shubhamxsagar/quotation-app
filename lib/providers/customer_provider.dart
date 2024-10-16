// providers/customer_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quotation/providers/auth_provider.dart';

// FirebaseFirestore instance provider
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Customer list provider
final customerListProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return ref.watch(firebaseFirestoreProvider)
        .collection('users')
        .doc(user.uid)
        .collection('customers')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                'name': doc['name'],
                'compname': doc['compname'],
                'mobile': doc['mobile'],
              };
            }).toList());
  } else {
    return const Stream.empty();
  }
});

// Function to add a customer
final addCustomerProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final user = ref.watch(authStateProvider).value;

  Future<void> addCustomer(Map<String, dynamic> customerData) async {
    if (user != null) {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('customers')
          .add(customerData);
    }
  }

  return addCustomer;
});
