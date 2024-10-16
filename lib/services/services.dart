import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPDFService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadPDF(File pdfFile) async {
    try {
      // Generate a unique file name
      String fileName = basename(pdfFile.path);

      // Upload the PDF to Firebase Storage
      TaskSnapshot snapshot = await storage
          .ref('pdfs/$fileName')
          .putFile(pdfFile);

      // Get the download URL of the uploaded PDF
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Store PDF metadata in Firestore
      await firestore.collection('pdfs').add({
        'name': fileName,
        'url': downloadURL,
        'uploadedAt': Timestamp.now(),
      });

      print('PDF uploaded successfully!');
    } catch (e) {
      print('Error uploading PDF: $e');
    }
  }
}
