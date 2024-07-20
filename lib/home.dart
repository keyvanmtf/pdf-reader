import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf_model.dart';

import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late File _pdfFile;
  final List<String> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectoryPath();
  }

  Future<void> _openFileExplorer() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // You can add more extensions here
    );
    if (resultFile != null && resultFile.files.isNotEmpty) {
      File file = File(resultFile.files.single.path!);

      setState(() {
        _pdfFile = file;
        _pdfFiles.add(file.path);
        _savePath();
      });
      _openPdfScreen();
    }
  }

  void _openPdfScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('PDF Viewer'),
                  ),
                  body: SfPdfViewer.file(
                    _pdfFile,
                  ),
                )));
  }

  Future<void> _savePath() async {
    var box = Hive.box<PdfModel>('pdfBox');
    var pdfModel = PdfModel(path: _pdfFiles);
    await box.put('path', pdfModel);
  }

  Future<void> _loadPath() async {
    var box = Hive.box<PdfModel>('pdfBox');
    PdfModel? pdfModel = box.get('path');
    if (pdfModel != null) {
      setState(() {
        _pdfFiles.clear();
        _pdfFiles.addAll(pdfModel.path);
      });
    }
  }

  Future<void> getApplicationDocumentsDirectoryPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDir.path;

    final String pdfPath = '$appDocPath/$_pdfFile';
    setState(() {
      _pdfFiles.add(pdfPath);
    });
  }

  // تابع برای بارگذاری مسیر پی دی اف
  // _loadPdfPath() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _pdfPath = prefs.getString('pdfPath') ?? '';
  //   });
  // }

  // // تابع برای ذخیره مسیر پی دی اف
  // _savePdfPath(String pdfPath) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _pdfPath = pdfPath;
  //     prefs.setString('pdfPath', pdfPath);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: Colors.blueAccent,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Icon(Icons.dock),
              label: 'Open File',
              onTap: _openFileExplorer,
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: _pdfFiles.length,
            itemBuilder: (context, index) {
              final pdfFile = _pdfFiles[index];
              final pdfName = path.basename(pdfFile);

              return ListTile(
                title: Text(pdfName),
                onTap: () {
                  setState(() {
                    _pdfFile = File(pdfFile);
                  });
                  _openPdfScreen();
                },
              );
            }));
  }
}
