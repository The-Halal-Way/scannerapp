import 'package:scannerapp/feature/coupons/data/models/coupon.dart';

abstract final class DemoCoupons {
  static const coupons = [
    Coupon(
      code: 'CARE10',
      title: 'A little extra care',
      minimumSpend: 500,
      percentOff: 10,
      maxDiscount: 200,
    ),
    Coupon(
      code: 'STOCK100',
      title: 'Save on your next restock',
      minimumSpend: 1200,
      amountOff: 100,
    ),
    Coupon(
      code: 'SHELF15',
      title: 'Bigger shelves, better savings',
      minimumSpend: 2000,
      percentOff: 15,
      maxDiscount: 400,
    ),
  ];
}
