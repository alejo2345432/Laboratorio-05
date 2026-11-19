import 'package:dart_lab_05/agrodiversa.dart';
import 'package:test/test.dart';

void main() {
  group('AgriculturalRecord', () {
    test('calculates total, average, and largest crop', () {
      final record = AgriculturalRecord(
        municipality: 'Andes',
        year: 2025,
        crops: [
          CropArea(name: 'Coffee', plantedArea: 125.0),
          CropArea(name: 'Plantain', plantedArea: 75.0),
          CropArea(name: 'Avocado', plantedArea: 50.0),
        ],
      );
      expect(record.totalArea, closeTo(250.0, 0.0001));
      expect(record.averageArea, closeTo(83.3333, 0.001));
      expect(record.largestCrop.name, equals('Coffee'));
    });

    test('rejects duplicates, invalid years, empty lists, and overflow', () {
      expect(
        () => AgriculturalRecord(
          municipality: 'Andes',
          year: 2025,
          crops: [
            CropArea(name: 'Coffee', plantedArea: 10.0),
            CropArea(name: 'coffee', plantedArea: 20.0),
          ],
        ),
        throwsFormatException,
      );
      expect(
        () => AgriculturalRecord(
          municipality: 'Andes',
          year: 1999,
          crops: [CropArea(name: 'Coffee', plantedArea: 10.0)],
        ),
        throwsFormatException,
      );
      expect(
        () => AgriculturalRecord(municipality: 'Andes', year: 2025, crops: []),
        throwsFormatException,
      );
      expect(
        () => AgriculturalRecord(
          municipality: 'Andes',
          year: 2025,
          crops: [
            CropArea(name: 'A', plantedArea: 1e308),
            CropArea(name: 'B', plantedArea: 1e308),
          ],
        ),
        throwsFormatException,
      );
    });
  });
}