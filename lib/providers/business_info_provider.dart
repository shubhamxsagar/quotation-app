import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quotation/providers/auth_provider.dart';

// Define Firebase Providers
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// BusinessInfoProvider for adding business data
final businessInfoProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final user = ref.watch(authStateProvider).value;

  Future<void> addBusinessInfo(Map<String, dynamic> businessData) async {
    print('Adding business info ${user?.uid}');
    if (user != null) {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('businessInfo')
          .add(businessData);
    }
  }

  return addBusinessInfo;
});
