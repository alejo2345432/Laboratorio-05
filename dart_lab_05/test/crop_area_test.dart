import 'package:dart_lab_05/agrodiversa.dart';
import 'package:test/test.dart';

void main() {
  group('CropArea', () {
    test('accepts valid crop and trims spaces', () {
      final crop = CropArea(name: ' Coffee ', plantedArea: 125.0);
      expect(crop.name, equals('Coffee'));
      expect(crop.plantedArea, equals(125.0));
    });

    test('rejects invalid names and areas', () {
      expect(() => CropArea(name: '', plantedArea: 10.0), throwsFormatException);
      expect(() => CropArea(name: '   ', plantedArea: 10.0), throwsFormatException);
      expect(() => CropArea(name: 'Coffee', plantedArea: -1.0), throwsFormatException);
      expect(() => CropArea(name: 'Coffee', plantedArea: 0.0), throwsFormatException);
      expect(() => CropArea(name: 'Coffee', plantedArea: double.nan), throwsFormatException);
      expect(() => CropArea(name: 'Coffee', plantedArea: double.infinity), throwsFormatException);
    });
  });
}