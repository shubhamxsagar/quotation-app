import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quotation/core/localstorage/localstorage.dart';
import 'package:quotation/lc.dart';
import 'package:quotation/routes/my_app_route.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout(BuildContext context) async {
    final localStorage = lc<LocalStorageRepository>();

    try {
      // Sign out the user from Firebase
      await _auth.signOut();

      // Remove UID from local storage
      await localStorage.removeUid();

      // Navigate to login screen
      context.goNamed(RouteConstants.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Account Section
          ListTile(
            title: Text('Account',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54)),
            tileColor: Colors.grey[200],
          ),
          _buildSettingsItem(context, 'Profile', Icons.person),
          _buildSettingsItem(context, 'Business Info', Icons.business),
          _buildSettingsItem(context, 'Subscription', Icons.subscriptions),
          _buildSettingsItem(context, 'Logout', Icons.logout,
              onTap: () => logout(context)),

          // Quotation, Invoice, Proforma, PO Section
          ListTile(
            title: Text('Quotation, Invoice, Proforma, PO',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54)),
            tileColor: Colors.grey[200],
          ),
          _buildSettingsItem(context, 'Quotation Settings', Icons.settings),
          _buildSettingsItem(context, 'Invoice Settings', Icons.receipt),
          _buildSettingsItem(
              context, 'Purchase Order Settings', Icons.assignment),
          _buildSettingsItem(
              context, 'Proforma Invoice Settings', Icons.assignment_outlined),
          _buildSettingsItem(
              context, 'Delivery Note Settings', Icons.local_shipping),
          _buildSettingsItem(context, 'Custom Heading(TAX, HSN, Other Charges)',
              Icons.settings_suggest),
          _buildSettingsItem(
              context, 'Date & Currency settings', Icons.date_range),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String title, IconData icon,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ?? () {}, // Default to a no-op if no action is provided
    );
  }
}
