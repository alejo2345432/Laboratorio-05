abstract interface class ReportFormatter {
  String format(String title, double area);
}

class CompactFormatter implements ReportFormatter {
  @override
  String format(String title, double area) =>
      '$title: ${area.toStringAsFixed(2)} ha';
}

class DetailedFormatter implements ReportFormatter {
  @override
  String format(String title, double area) =>
      'Observation $title reports ${area.toStringAsFixed(2)} hectares.';
}

class MinimalFormatter implements ReportFormatter {
  @override
  String format(String title, double area) => title;
}