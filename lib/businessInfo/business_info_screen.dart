import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:quotation/providers/business_info_provider.dart';

class BusinessInfoForm extends ConsumerStatefulWidget {
  @override
  _BusinessInfoFormState createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends ConsumerState<BusinessInfoForm> {
  final compNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final gstLabelController = TextEditingController();
  final gstNumberController = TextEditingController();

  File? _logoImage;
  File? _signatureImage;

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (isLogo) {
        _logoImage = pickedFile != null ? File(pickedFile.path) : null;
      } else {
        _signatureImage = pickedFile != null ? File(pickedFile.path) : null;
      }
    });
  }

  Future<String?> uploadImageToStorage(File? imageFile, String folder) async {
    if (imageFile == null) return null;

    try {
      // Create a reference to the Firebase storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('$folder/${DateTime.now().millisecondsSinceEpoch}.png');

      // Upload the image file
      final uploadTask = await storageRef.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Widget _imageButton(File? imageFile, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      label,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: Icon(
              Icons.edit,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Info',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo and Signature buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      _imageButton(
                          _logoImage, 'ADD LOGO', () => _pickImage(true)),
                    ],
                  ),
                  Column(
                    children: [
                      _imageButton(_signatureImage, 'ADD SIGNATURE',
                          () => _pickImage(false)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Form fields
              TextField(
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
                controller: compNameController,
                decoration: InputDecoration(
                  labelText: 'Business Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              TextField(
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
                controller: address1Controller,
                decoration: InputDecoration(
                  labelText: 'Address 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
                controller: address2Controller,
                decoration: InputDecoration(
                  labelText: 'Address 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
                controller: gstLabelController,
                decoration: InputDecoration(
                  labelText: 'GSTIN/PAN/VAT/Business Label',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
                controller: gstNumberController,
                decoration: InputDecoration(
                  labelText: 'GSTIN/PAN/VAT/Business Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Save button
              ElevatedButton(
                onPressed: () async {
                  final addBusinessInfo = ref.watch(businessInfoProvider);

                  // Upload logo and signature images
                  String? logoUrl =
                      await uploadImageToStorage(_logoImage, 'logos');
                  String? signatureUrl =
                      await uploadImageToStorage(_signatureImage, 'signatures');

                  // Prepare business info data with image URLs
                  final businessInfoData = {
                    'compName': compNameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address1': address1Controller.text,
                    'address2': address2Controller.text,
                    'address3': address3Controller.text,
                    'gstLabel': gstLabelController.text,
                    'gstNumber': gstNumberController.text,
                    'logoUrl': logoUrl,
                    'signatureUrl': signatureUrl,
                  };

                  // Save business info to Firestore
                  await addBusinessInfo(businessInfoData);

                  // Show success message or navigate back
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Business info saved successfully')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
