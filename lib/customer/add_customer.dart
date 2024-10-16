import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotation/providers/customer_provider.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController compNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController shippController = TextEditingController();

  String selectedState = '';
  bool isStateModalVisible = false;

  List<String> statesList = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Lakshadweep',
    'Delhi',
    'Puducherry',
    'Ladakh',
    'Jammu and Kashmir'
  ];

  Future<void> addCustomer() async {
    final textTheme = Theme.of(context).textTheme;
    if (nameController.text.isEmpty ||
        compNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty) {
      showDialog(
        
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
                title: Text('Validation Error', style: textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                content: Text('Please fill in all required fields.',style: TextStyle(color: Colors.black, fontSize: 16)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK', style: textTheme.displayMedium?.copyWith(fontSize: 16),),
                  )
                ],
              ));
      return;
    }

    try {
      final addCustomer = ref.read(addCustomerProvider);
      await addCustomer({
        'name': nameController.text,
        'compname': compNameController.text,
        'email': emailController.text,
        'mobile': mobileController.text,
        'address': addressController.text,
        'gst': gstController.text,
        'state': selectedState,
        'shipp': shippController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,

                title: Text('Success', style:textTheme.displayMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                content: Text('Customer added successfully!', style: textTheme.displayMedium?.copyWith(fontSize: 16),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  )
                ],
              ));
      clearFields();
    } catch (e) {
      print('Error adding customer: $e');
    }
  }

  void clearFields() {
    nameController.clear();
    compNameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    gstController.clear();
    shippController.clear();
    setState(() {
      selectedState = '';
    });
  }

  void selectState(String state) {
    setState(() {
      selectedState = state;
      isStateModalVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Customer',
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
            // Name TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Company Name TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: compNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Email TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Mobile TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Address TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address 1',
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
              decoration: InputDecoration(
                labelText: 'GSTIN Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            // State Dropdown
            GestureDetector(
              onTap: () {
                setState(() {
                  isStateModalVisible = true;
                });
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedState.isEmpty ? 'Select State' : selectedState,
                      style: textTheme.displayMedium?.copyWith(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Shipping Address TextField
            TextField(
              style: textTheme.displayMedium?.copyWith(fontSize: 16),
              controller: shippController,
              decoration: InputDecoration(
                labelText: 'Shipping Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Add Customer Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addCustomer,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add',
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
      bottomSheet: isStateModalVisible
          ? Container(
              height: 300,
              child: ListView.builder(
                itemCount: statesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(statesList[index]),
                    onTap: () => selectState(statesList[index]),
                  );
                },
              ),
            )
          : null,
    );
  }
}
