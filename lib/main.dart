import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf/pdf_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pdf/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // اطمینان از مقداردهی صحیح
  await Hive.initFlutter(); // مقداردهی اولیه Hive
  Hive.registerAdapter(PdfModelAdapter()); // ثبت Adapter
  // await Hive.openBox<PdfModel>('pdfBox'); // باز کردن Box
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
