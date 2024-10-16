import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quotation/providers/auth_provider.dart';
import 'package:quotation/providers/business_info_provider.dart';
import 'package:quotation/quotation/pdf_viewer.dart';

class PDFListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final pdfsStream = ref.watch(uploadedPdfsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ouotation List',
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
      body: pdfsStream.when(
        data: (pdfs) {
          if (pdfs.isEmpty) {
            return Center(
                child: Text(
              'No PDFs uploaded yet.',
              style: textTheme.displayMedium
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ));
          }
          return ListView.builder(
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              return ListTile(
                title: Text(pdf['fileName'],
                    style: textTheme.displayMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.picture_as_pdf),
                onTap: () {
                  // Open the PDF using URL
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFWebViewer(pdf['url']),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
            child: Text('Error: $error',
                style: textTheme.displayMedium
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500))),
      ),
    );
  }
}

// Provider to stream uploaded PDFs from Firestore
final uploadedPdfsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final user = ref.watch(authStateProvider).value;

  return firestore
      .collection("users")
      .doc(user?.uid)
      .collection('uploaded_pdfs')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList();
  });
});
