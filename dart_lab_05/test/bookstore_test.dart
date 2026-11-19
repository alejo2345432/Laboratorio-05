import 'package:dart_lab_05/bookstore.dart';
import 'package:test/test.dart';
import '../bin/bookstore_cli.dart' as cli;

void main() {
  group('Bookstore', () {
    final codec = OrderJsonCodec();

    test('calculates subtotals and order total', () {
      final order = BookOrder(
        id: 'ORD-1',
        customerName: 'Ana',
        items: [OrderItem(name: 'Book', quantity: 2, unitPrice: 25.0)],
      );
      expect(order.totalAmount, equals(50.0));
    });

    test('rejects duplicate IDs and invalid items', () {
      expect(() => OrderItem(name: '', quantity: 1, unitPrice: 10), throwsFormatException);
      expect(
        () => codec.decodeOrders('''[
          {"id":"ord-1","customerName":"A","items":[{"name":"B","quantity":1,"unitPrice":10}]},
          {"id":"ORD-1","customerName":"C","items":[{"name":"D","quantity":1,"unitPrice":20}]}
        ]'''),
        throwsFormatException,
      );
    });

    test('selects formatters properly', () {
      expect(cli.selectFormatter([]), isA<CompactOrderFormatter>());
      expect(cli.selectFormatter(['detailed']), isA<DetailedOrderFormatter>());
      expect(cli.selectFormatter(['other']), isNull);
    });
  });
}