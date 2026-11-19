import 'package:dart_lab_05/src/services/record_json_codec.dart';
import 'package:test/test.dart';

void main() {
  group('RecordJsonCodec', () {
    final codec = RecordJsonCodec();

    test('decodes and encodes valid records', () {
      const jsonStr = '[{"municipality":"Andes","year":2025,"crops":[{"name":"Coffee","plantedArea":125}]}]';
      final records = codec.decodeRecords(jsonStr);
      expect(records, hasLength(1));
      expect(records.first.totalArea, equals(125.0));

      final reDecoded = codec.decodeRecords(codec.encodeRecords(records));
      expect(reDecoded.first.municipality, equals('Andes'));
    });

    test('rejects malformed structure or duplicate municipality+year', () {
      expect(() => codec.decodeRecords('{"municipality":"Andes"}'), throwsFormatException);
      expect(
        () => codec.decodeRecords('[{"municipality":"Andes","year":2025,"crops":[{"name":"Coffee","plantedArea":"bad"}]}]'),
        throwsFormatException,
      );
      expect(
        () => codec.decodeRecords('''[
          {"municipality":"Andes","year":2025,"crops":[{"name":"Coffee","plantedArea":10}]},
          {"municipality":"andes","year":2025,"crops":[{"name":"Beans","plantedArea":20}]}
        ]'''),
        throwsFormatException,
      );
    });
  });
}