import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:path_provider/path_provider.dart';

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
    _loadPaths();
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
        _savePaths();
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

  // Future<void> _savePath() async {
  //   var box = Hive.box<PdfModel>('pdfBox');
  //   var pdfModel = PdfModel(path: _pdfFiles);
  //   await box.put('path', pdfModel);
  // }

  // Future<void> _loadPath() async {
  //   var box = Hive.box<PdfModel>('pdfBox');
  //   PdfModel? pdfModel = box.get('path');
  //   if (pdfModel != null) {
  //     setState(() {
  //       _pdfFiles.clear();
  //       _pdfFiles.addAll(pdfModel.path);
  //     });
  //   }
  // }

  Future<void> _savePaths() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/pdf_paths.txt');
    await file.writeAsString(_pdfFiles.join('\n'));
  }

  Future<void> _loadPaths() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pdf_paths.txt');
      final contents = await file.readAsString();
      setState(() {
        _pdfFiles.addAll(contents.split('\n').where((path) => path.isNotEmpty));
      });
    } catch (e) {
      // If encountering an error, return an empty list
      print('Error loading paths: $e');
    }
  }

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
