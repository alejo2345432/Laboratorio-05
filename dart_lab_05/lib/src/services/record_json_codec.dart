import 'dart:convert';
import '../model/agricultural_record.dart';
import '../model/crop_area.dart';

class RecordJsonCodec {
  List<AgriculturalRecord> decodeRecords(String source) {
    Object? root = jsonDecode(source);
    if (root is! List<dynamic>) {
      throw FormatException('Expected a JSON array of observations.');
    }

    List<AgriculturalRecord> records = <AgriculturalRecord>[];
    Set<String> uniqueKeys = <String>{};

    for (final rawRecord in root) {
      if (rawRecord is! Map<String, dynamic>) {
        throw FormatException('Every observation must be an object.');
      }

      Object? municipality = rawRecord['municipality'];
      Object? year = rawRecord['year'];
      Object? rawCrops = rawRecord['crops'];

      if (municipality is! String || year is! int || rawCrops is! List<dynamic>) {
        throw FormatException('Invalid observation fields.');
      }

      List<CropArea> crops = <CropArea>[];
      for (final rawCrop in rawCrops) {
        if (rawCrop is! Map<String, dynamic>) {
          throw FormatException('Every crop must be an object.');
        }
        Object? name = rawCrop['name'];
        Object? plantedArea = rawCrop['plantedArea'];

        if (name is! String || plantedArea is! num) {
          throw FormatException('Invalid crop fields.');
        }

        crops.add(CropArea(name: name, plantedArea: plantedArea.toDouble()));
      }

      AgriculturalRecord record = AgriculturalRecord(
        municipality: municipality,
        year: year,
        crops: crops,
      );

      String key = '${record.municipality.toLowerCase()} (${record.year})';
      if (!uniqueKeys.add(key)) {
        throw FormatException('Duplicate municipality and year: $key');
      }

      records.add(record);
    }
    return records;
  }

  String encodeRecords(List<AgriculturalRecord> records) {
    List<Map<String, Object?>> data = records.map((record) {
      return <String, Object?>{
        'municipality': record.municipality,
        'year': record.year,
        'crops': record.crops.map((crop) {
          return <String, Object?>{
            'name': crop.name,
            'plantedArea': crop.plantedArea,
          };
        }).toList(),
      };
    }).toList();

    return const JsonEncoder.withIndent('  ').convert(data);
  }
}