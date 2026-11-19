import 'dart:convert';
import '../model/book_order.dart';
import '../model/order_item.dart';

class OrderJsonCodec {
  List<BookOrder> decodeOrders(String source) {
    Object? root = jsonDecode(source);
    if (root is! List<dynamic>) throw FormatException('Expected a JSON array.');

    List<BookOrder> orders = [];
    Set<String> ids = {};

    for (final raw in root) {
      if (raw is! Map<String, dynamic>) throw FormatException('Invalid order object.');
      Object? id = raw['id'];
      Object? customer = raw['customerName'];
      Object? rawItems = raw['items'];

      if (id is! String || customer is! String || rawItems is! List<dynamic>) {
        throw FormatException('Invalid order fields.');
      }

      List<OrderItem> items = [];
      for (final rawItem in rawItems) {
        if (rawItem is! Map<String, dynamic>) throw FormatException('Invalid item.');
        Object? name = rawItem['name'];
        Object? qty = rawItem['quantity'];
        Object? price = rawItem['unitPrice'];

        if (name is! String || qty is! int || price is! num) {
          throw FormatException('Invalid item fields.');
        }
        items.add(OrderItem(name: name, quantity: qty, unitPrice: price.toDouble()));
      }

      BookOrder order = BookOrder(id: id, customerName: customer, items: items);
      if (!ids.add(order.id.toLowerCase())) {
        throw FormatException('Duplicate order ID: ${order.id}');
      }
      orders.add(order);
    }
    return orders;
  }

  String encodeOrders(List<BookOrder> orders) {
    final data = orders.map((o) => {
      'id': o.id,
      'customerName': o.customerName,
      'items': o.items.map((i) => {
        'name': i.name,
        'quantity': i.quantity,
        'unitPrice': i.unitPrice,
      }).toList(),
    }).toList();
    return const JsonEncoder.withIndent('  ').convert(data);
  }
}