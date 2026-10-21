class Coupon {
  const Coupon({
    required this.code,
    required this.title,
    required this.minimumSpend,
    this.percentOff = 0,
    this.amountOff = 0,
    this.maxDiscount,
  });

  final String code;
  final String title;
  final int minimumSpend;
  final int percentOff;
  final int amountOff;
  final int? maxDiscount;

  String get savingsLabel => percentOff > 0 ? '$percentOff%' : '৳$amountOff';

  int discountFor(int subtotal) {
    if (subtotal < minimumSpend) return 0;
    final discount = percentOff > 0
        ? (subtotal * percentOff / 100).round()
        : amountOff;
    return discount.clamp(0, maxDiscount ?? subtotal).clamp(0, subtotal);
  }
}
