class Product {
  const Product({
    required this.id,
    required this.name,
    required this.genericName,
    required this.companyId,
    required this.categoryId,
    required this.unit,
    required this.price,
    required this.originalPrice,
    required this.stock,
    required this.description,
    this.isPopular = false,
    this.isOffer = false,
  });

  final String id;
  final String name;
  final String genericName;
  final String companyId;
  final String categoryId;
  final String unit;
  final int price;
  final int originalPrice;
  final int stock;
  final String description;
  final bool isPopular;
  final bool isOffer;

  int get discountPercent => originalPrice <= price
      ? 0
      : ((originalPrice - price) * 100 / originalPrice).round();
}
