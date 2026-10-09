// Order Item model representing an item in an order
class OrderItemModel {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    this.imageUrl = '',
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> data) {
    return OrderItemModel(
      productId: data['productId'] as String? ?? data['id'] as String? ?? '',
      title: data['title'] as String? ?? data['name'] as String? ?? 'Item',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ??
          (data['count'] as num?)?.toInt() ??
          1,
      imageUrl: data['imageUrl'] as String? ??
          data['image'] as String? ??
          data['img'] as String? ??
          '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

// Order model representing documents in the 'orders' collection
class OrderModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final double totalAmount;
  final String status; // Pending, Processing, Delivered, Cancelled
  final DateTime orderDate;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.items,
  });

  // Convert Firestore document snapshot to OrderModel
  factory OrderModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    // Parse order date safely
    DateTime parsedDate;
    if (data['placedAt'] != null) {
      if (data['placedAt'] is String) {
        parsedDate = DateTime.tryParse(data['placedAt'] as String) ?? DateTime.now();
      } else {
        try {
          parsedDate = (data['placedAt']).toDate();
        } catch (_) {
          parsedDate = DateTime.now();
        }
      }
    } else if (data['orderDate'] != null) {
      if (data['orderDate'] is String) {
        parsedDate = DateTime.tryParse(data['orderDate'] as String) ?? DateTime.now();
      } else {
        // If it's a Firestore Timestamp or other object
        try {
          parsedDate = (data['orderDate']).toDate();
        } catch (_) {
          parsedDate = DateTime.now();
        }
      }
    } else if (data['createdAt'] != null) {
      if (data['createdAt'] is String) {
        parsedDate = DateTime.tryParse(data['createdAt'] as String) ?? DateTime.now();
      } else {
        try {
          parsedDate = (data['createdAt']).toDate();
        } catch (_) {
          parsedDate = DateTime.now();
        }
      }
    } else {
      parsedDate = DateTime.now();
    }

    // Parse items list
    List<OrderItemModel> parsedItems = [];
    if (data['items'] is List) {
      parsedItems = (data['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => OrderItemModel.fromMap(item))
          .toList();
    }

    // Combine address and pin if pin exists
    String fullAddress = data['shippingAddress'] as String? ?? data['address'] as String? ?? 'No address provided';
    final pin = data['pin'] as String?;
    if (pin != null && pin.isNotEmpty && !fullAddress.contains(pin)) {
      fullAddress = '$fullAddress (PIN: $pin)';
    }

    return OrderModel(
      id: documentId,
      userId: data['userId'] as String? ?? '',
      customerName: data['customerName'] as String? ??
          data['userName'] as String? ??
          data['userEmail'] as String? ??
          'Customer',
      customerPhone: data['customerPhone'] as String? ?? data['phone'] as String? ?? 'N/A',
      shippingAddress: fullAddress,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ??
          (data['total'] as num?)?.toDouble() ??
          0.0,
      status: data['status'] as String? ?? 'Pending',
      orderDate: parsedDate,
      items: parsedItems,
    );
  }

  // Convert to Map for Firestore update operations
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'shippingAddress': shippingAddress,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((i) => i.toMap()).toList(),
    };
  }
}
