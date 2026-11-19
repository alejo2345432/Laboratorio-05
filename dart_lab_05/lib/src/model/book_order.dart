import 'order_item.dart';

class BookOrder {
  final String id;
  final String customerName;
  final List<OrderItem> items;

  BookOrder({
    required String id,
    required String customerName,
    required List<OrderItem> items,
  })  : id = id.trim(),
        customerName = customerName.trim(),
        items = List<OrderItem>.unmodifiable(items) {
    if (this.id.isEmpty) throw FormatException('Order ID cannot be empty.');
    if (this.customerName.isEmpty) throw FormatException('Customer name empty.');
    if (this.items.isEmpty) throw FormatException('Order needs at least 1 item.');
    if (!totalAmount.isFinite) throw FormatException('Order total not finite.');
  }

  double get totalAmount =>
      items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
}