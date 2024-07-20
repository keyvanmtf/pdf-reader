// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfModelAdapter extends TypeAdapter<PdfModel> {
  @override
  final int typeId = 0;

  @override
  PdfModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfModel(
      path: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PdfModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
