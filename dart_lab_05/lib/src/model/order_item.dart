class OrderItem {
  final String name;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required String name,
    required this.quantity,
    required this.unitPrice,
  }) : name = name.trim() {
    if (this.name.isEmpty) throw FormatException('Empty book name.');
    if (quantity <= 0) throw FormatException('Quantity must be > 0.');
    if (!unitPrice.isFinite || unitPrice <= 0) {
      throw FormatException('Unit price must be positive and finite.');
    }
    if (!subtotal.isFinite) throw FormatException('Subtotal is not finite.');
  }

  double get subtotal => quantity * unitPrice;
}