import 'dart:io';
import 'package:dart_lab_05/agrodiversa.dart';
import 'package:dart_lab_05/src/services/record_json_codec.dart';

ReportFormatter? selectFormatter(List<String> arguments) {
  String format = arguments.isEmpty ? 'compact' : arguments.first;
  if (arguments.length > 1) return null;

  switch (format) {
    case 'compact':
      return CompactFormatter();
    case 'detailed':
      return DetailedFormatter();
    default:
      return null;
  }
}

void main(List<String> arguments) {
  ReportFormatter? formatter = selectFormatter(arguments);

  if (formatter == null) {
    stderr.writeln('Usage: dart run bin/agrodiversa_cli.dart [compact|detailed]');
    exitCode = 2;
    return;
  }

  File sourceFile = File('data/observations.json');
  File outputFile = File('data/normalized_observations.json');
  RecordJsonCodec codec = RecordJsonCodec();

  try {
    String source = sourceFile.readAsStringSync();
    List<AgriculturalRecord> records = codec.decodeRecords(source);

    if (records.isEmpty) {
      print('No observations available.');
    } else {
      print('Valid observations: ${records.length}\n');
      int totalCrops = 0;

      for (final record in records) {
        double total = record.totalArea;
        double average = record.averageArea;
        CropArea largest = record.largestCrop;
        double share = (largest.plantedArea / total) * 100;
        totalCrops += record.crops.length;

        String title = '${record.municipality} (${record.year})';
        print(formatter.format(title, total));
        print('  Cultivos: ${record.crops.length}');
        print('  Promedio: ${average.toStringAsFixed(2)} ha');
        print(
          '  Mayor cultivo: ${largest.name} '
          '(${largest.plantedArea.toStringAsFixed(2)} ha - ${share.toStringAsFixed(2)}%)',
        );
      }

      double grandTotal =
          records.fold<double>(0.0, (sum, r) => sum + r.totalArea);

      if (!grandTotal.isFinite) {
        throw FormatException('Combined area is not finite.');
      }

      print('\nTotal registros de cultivo: $totalCrops');
      print('Total general: ${grandTotal.toStringAsFixed(2)} ha');
    }

    String normalizedJson = codec.encodeRecords(records);
    outputFile.writeAsStringSync(normalizedJson);
    print('Exportado en: ${outputFile.path}');
  } on FileSystemException catch (error) {
    stderr.writeln('File error: ${error.message}');
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('Invalid agricultural data: ${error.message}');
    exitCode = 1;
  }
}