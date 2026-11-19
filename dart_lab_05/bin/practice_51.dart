// 1. Clases y constructores
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required this.name, required this.plantedArea});

  String describe() {
    return '$name: $plantedArea ha';
  }
}

// 2 y 3. Clases abstractas, herencia y polimorfismo
abstract class Report {
  String get title;

  String describe() {
    return 'Report: $title';
  }
}

class MunicipalReport extends Report {
  @override
  final String title;

  MunicipalReport(this.title);
}

class DepartmentReport extends Report {
  @override
  final String title;

  DepartmentReport(this.title);

  @override
  String describe() => 'Department report: $title';
}

class SummaryReport extends Report {
  @override
  final String title;

  SummaryReport(this.title);

  @override
  String describe() => 'Executive summary: $title';
}

void showDescription(Report report) {
  print(report.describe());
}

// 4 y 5. Interfaces en Dart 3 y composición por constructor
abstract interface class ReportFormatter {
  String format(String title, double area);
}

class CompactFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    String value = area.toStringAsFixed(2);
    return '$title: $value ha';
  }
}

class VerboseFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    String value = area.toStringAsFixed(2);
    return 'Observation $title reports $value hectares.';
  }
}

class ReportPrinter {
  final ReportFormatter formatter;

  ReportPrinter(this.formatter);

  void printReport(String title, double area) {
    print(formatter.format(title, area));
  }
}

void main() {
  print('--- 1. Clases y constructores ---');
  CropArea coffee = CropArea(name: 'Coffee', plantedArea: 125.0);
  CropArea beans = CropArea(name: 'Beans', plantedArea: 40.0);
  CropArea cocoa = CropArea(name: 'Cocoa', plantedArea: 18.5);

  print(coffee.describe());
  print(beans.describe());
  print(cocoa.describe());

  print('\n--- 2 y 3. Herencia y polimorfismo ---');
  Report municipal = MunicipalReport('Andes 2025');
  Report department = DepartmentReport('Antioquia 2025');
  Report summary = SummaryReport('National Consolidation');

  showDescription(municipal);
  showDescription(department);
  showDescription(summary);

  print('\n--- 4 y 5. Interfaces y composición ---');
  ReportPrinter compactPrinter = ReportPrinter(CompactFormatter());
  ReportPrinter verbosePrinter = ReportPrinter(VerboseFormatter());

  compactPrinter.printReport('Andes 2025', 125.0);
  verbosePrinter.printReport('Andes 2025', 125.0);
}