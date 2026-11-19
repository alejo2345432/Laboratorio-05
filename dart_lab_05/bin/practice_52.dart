class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) {
      throw FormatException('Crop name must not be empty.');
    }
    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw FormatException('Planted area must be positive and finite.');
    }
  }
}

void showMunicipality(String? municipality) {
  if (municipality == null) {
    print('Municipality is missing.');
    return;
  }
  print(municipality.trim().toLowerCase());
}

void parseYear(String text) {
  try {
    print(int.parse(text));
  } on FormatException {
    print('Invalid year format.');
  } finally {
    print('Parsing attempt finished.');
  }
}

void validateArea(double area) {
  if (!area.isFinite || area <= 0) {
    throw FormatException('Invalid area.');
  }
}

void processArea(double area) {
  try {
    validateArea(area);
  } on FormatException {
    print('Validation failed.');
    rethrow;
  }
}

void main() {
  // Ejercicio 1: Null safety
  String? municipality = 'Andes';
  print(municipality);
  municipality = null;
  print(municipality ?? 'No municipality');

  showMunicipality(null);
  showMunicipality(' Andes ');

  // Ejercicio 3: Probar textos
  for (final text in ['abc', '-3', '0', 'Infinity', '12.5']) {
    double? area = double.tryParse(text);
    if (area == null || !area.isFinite || area <= 0) {
      print('$text -> Enter a positive finite area.');
    } else {
      print('$text -> Accepted area: $area');
    }
  }

  // Reto: Probar 5 CropArea
  final datos = [
    (' Coffee ', 125.0),
    ('', 10.0),
    ('   ', 15.0),
    ('Beans', -5.0),
    ('Cocoa', double.nan),
  ];

  for (final item in datos) {
    try {
      CropArea c = CropArea(name: item.$1, plantedArea: item.$2);
      print('Válido: ${c.name} - ${c.plantedArea}');
    } on FormatException catch (e) {
      print('Error esperado: ${e.message}');
    }
  }

  // Ejercicio 6: finally y rethrow
  parseYear('2025');
  parseYear('invalid');

  try {
    processArea(-1.0);
  } on FormatException {
    print('Caller handled the error.');
  }

  // Corrección de práctica incorrecta (mostrar error en vez de ocultarlo)
  try {
    int year = int.parse('invalid');
    print(year);
  } on FormatException catch (e) {
    print('Error capturado explícitamente: ${e.message}');
  }
  print('Operation completed.');
}