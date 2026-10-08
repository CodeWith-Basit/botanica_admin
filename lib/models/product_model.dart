// Product model representing items in the 'products' Firestore collection.
class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.stock = 0,
  });

  // Convert Firestore document snapshot to ProductModel
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      title: data['title'] as String? ?? data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] as String? ?? 'General',
      imageUrl: data['imageUrl'] as String? ?? data['image'] as String? ?? '',
      stock: (data['stock'] as num?)?.toInt() ?? 0,
    );
  }

  // Convert ProductModel to a Map for saving in Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'name': title, // compatibility with existing apps
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'image': imageUrl, // compatibility with existing apps
      'stock': stock,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
