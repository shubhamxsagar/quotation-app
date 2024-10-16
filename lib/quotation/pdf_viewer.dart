import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFWebViewer extends StatelessWidget {
  final String pdfUrl;

  PDFWebViewer(this.pdfUrl);

  @override
  Widget build(BuildContext context) {
    print("PDF URL: $pdfUrl");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quotation',
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
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
