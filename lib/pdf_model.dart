import 'package:hive/hive.dart';

part 'pdf_model.g.dart';

@HiveType(typeId: 0) // استفاده از typeId: 0
class PdfModel {
  @HiveField(0)
  List<String> path;

  PdfModel({required this.path});
}
