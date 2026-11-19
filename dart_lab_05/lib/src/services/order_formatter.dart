import '../model/book_order.dart';

abstract interface class OrderFormatter {
  String format(BookOrder order);
}

class CompactOrderFormatter implements OrderFormatter {
  @override
  String format(BookOrder order) =>
      'Order #${order.id} - ${order.customerName}: \$${order.totalAmount.toStringAsFixed(2)}';
}

class DetailedOrderFormatter implements OrderFormatter {
  @override
  String format(BookOrder order) {
    final details = order.items
        .map((i) => '  * ${i.name} (x${i.quantity}): \$${i.subtotal.toStringAsFixed(2)}')
        .join('\n');
    return 'Order #${order.id} | Customer: ${order.customerName}\n'
        '$details\n'
        'Total: \$${order.totalAmount.toStringAsFixed(2)}';
  }
}