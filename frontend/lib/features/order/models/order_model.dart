class OrderItemRequest {
  final int productId;
  final int quantity;

  OrderItemRequest({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {'productId': productId, 'quantity': quantity};
}

class OrderRequest {
  final List<OrderItemRequest> items;
  OrderRequest({required this.items});

  Map<String, dynamic> toJson() => {'items': items.map((item) => item.toJson()).toList()};
}

// --- ADD THESE FOR RESPONSES ---
class OrderItemResponse {
  final String productName;
  final int quantity;
  final double price;

  OrderItemResponse({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      productName: json['productName'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class OrderResponse {
  final int id;
  final String userEmail;
  final DateTime orderDate;
  final double totalPrice;
  final List<OrderItemResponse> items;

  OrderResponse({
    required this.id,
    required this.userEmail,
    required this.orderDate,
    required this.totalPrice,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItemResponse> orderItems =
        itemsList.map((i) => OrderItemResponse.fromJson(i)).toList();

    return OrderResponse(
      id: json['id'],
      userEmail: json['userEmail'],
      orderDate: DateTime.parse(json['orderDate']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      items: orderItems,
    );
  }
}