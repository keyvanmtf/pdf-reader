import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatelessWidget {
  final File pdfFile;

  PdfScreen({
    super.key,
    required this.pdfFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: SfPdfViewer.file(
        pdfFile,
      ),
    );
  }
}
