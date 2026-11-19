import 'crop_area.dart';

class AgriculturalRecord {
  final String municipality;
  final int year;
  final List<CropArea> crops;

  AgriculturalRecord({
    required String municipality,
    required this.year,
    required List<CropArea> crops,
  })  : municipality = municipality.trim(),
        crops = List<CropArea>.unmodifiable(crops) {
    if (this.municipality.isEmpty) {
      throw FormatException('Municipality must not be empty.');
    }
    if (year < 2000 || year > 2100) {
      throw FormatException('Year must be between 2000 and 2100.');
    }
    if (this.crops.isEmpty) {
      throw FormatException('At least one crop is required.');
    }

    Set<String> uniqueNames = <String>{};
    for (final crop in this.crops) {
      if (!uniqueNames.add(crop.name.toLowerCase())) {
        throw FormatException('Duplicate crop name: ${crop.name}');
      }
    }

    if (!totalArea.isFinite) {
      throw FormatException('Total planted area is not finite.');
    }
  }

  double get totalArea =>
      crops.fold<double>(0.0, (total, crop) => total + crop.plantedArea);

  double get averageArea => totalArea / crops.length;

  CropArea get largestCrop {
    CropArea largest = crops.first;
    for (final crop in crops.skip(1)) {
      if (crop.plantedArea > largest.plantedArea) {
        largest = crop;
      }
    }
    return largest;
  }
}