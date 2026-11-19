import 'dart:io';
import 'package:dart_lab_05/bookstore.dart';

OrderFormatter? selectFormatter(List<String> args) {
  String mode = args.isEmpty ? 'compact' : args.first;
  if (args.length > 1) return null;
  if (mode == 'compact') return CompactOrderFormatter();
  if (mode == 'detailed') return DetailedOrderFormatter();
  return null;
}

void main(List<String> args) {
  OrderFormatter? formatter = selectFormatter(args);
  if (formatter == null) {
    stderr.writeln('Usage: dart run bin/bookstore_cli.dart [compact|detailed]');
    exitCode = 2;
    return;
  }

  File input = File('data/orders.json');
  File output = File('data/normalized_orders.json');
  OrderJsonCodec codec = OrderJsonCodec();

  try {
    List<BookOrder> orders = codec.decodeOrders(input.readAsStringSync());
    if (orders.isEmpty) {
      print('No orders available.');
    } else {
      for (final order in orders) {
        print(formatter.format(order));
      }
      double totalSales = orders.fold(0.0, (sum, o) => sum + o.totalAmount);
      if (!totalSales.isFinite) throw FormatException('Sales total not finite.');
      print('\nTotal Sales: \$${totalSales.toStringAsFixed(2)}');
    }
    output.writeAsStringSync(codec.encodeOrders(orders));
    print('Exported to: ${output.path}');
  } on FileSystemException catch (e) {
    stderr.writeln('File error: ${e.message}');
    exitCode = 1;
  } on FormatException catch (e) {
    stderr.writeln('Invalid order data: ${e.message}');
    exitCode = 1;
  }
}