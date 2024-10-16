import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Quotation date provider (initially set to current date)
final quotationDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Selected customer provider
final selectedCustomerProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// Other Charges Provider
final otherChargesProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

// List of selected products provider
// Selected Products Provider
final selectedProductsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

// Quotation Summary Provider: Calculates Total GST and Total Amount in real-time
final quotationSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final products = ref.watch(selectedProductsProvider);
  final otherCharges = ref.watch(otherChargesProvider);
  
  double totalGst = 0;
  double totalAmount = 0;
  double totalOtherCharges = 0;

  // Calculate total from products
  for (var product in products) {
    final price = product['price'] as double;
    final gst = product['gst'] as double;
    final quantity = product['quantity'] ?? 1;
    final discount = product['discount'] ?? 0.0;

    double discountedAmount = (price * quantity) - discount;
    double gstAmount = discountedAmount * (gst / 100);
    totalGst += gstAmount;
    totalAmount += discountedAmount + gstAmount;
  }

  // Calculate other charges and add to total
  for (var charge in otherCharges) {
    final chargeAmount = charge['amount'] as double;
    final isTaxable = charge['isTaxable'] as bool;
    final taxPercentage = charge['taxPercentage'] as double;

    if (isTaxable) {
      final taxAmount = chargeAmount * (taxPercentage / 100);
      totalGst += taxAmount; // Add charge GST to total GST
      totalOtherCharges += chargeAmount + taxAmount;
    } else {
      totalOtherCharges += chargeAmount;
    }
  }

  totalAmount += totalOtherCharges; // Add other charges to total amount

  return {
    'totalGst': totalGst,
    'totalOtherCharges': totalOtherCharges,
    'totalAmount': totalAmount,
  };
});
