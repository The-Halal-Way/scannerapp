import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/coupons/data/demo_coupons.dart';
import 'package:scannerapp/feature/coupons/presentation/widgets/coupon_ticket_card.dart';

class CouponPickerSheet extends StatefulWidget {
  const CouponPickerSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: context.appColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const CouponPickerSheet(),
  );

  @override
  State<CouponPickerSheet> createState() => _CouponPickerSheetState();
}

class _CouponPickerSheetState extends State<CouponPickerSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply(String code) {
    final error = context.read<ShopProvider>().applyCoupon(code);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final colors = context.appColors;
    final accents = [colors.brand, colors.cyan, colors.coral];
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final availableHeight = MediaQuery.sizeOf(context).height - keyboardHeight;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: availableHeight * .82,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.strokeStrong,
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Available coupons',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close coupons',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(AppIcons.close, size: 18),
                    ),
                  ],
                ),
                Text(
                  'Choose one coupon per order.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.done,
                        onSubmitted: _apply,
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
                          errorText: _error,
                          errorMaxLines: 2,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () => _apply(_controller.text),
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: DemoCoupons.coupons.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final coupon = DemoCoupons.coupons[index];
                      final eligible = shop.cartSubtotal >= coupon.minimumSpend;
                      final applied =
                          eligible && shop.appliedCoupon?.code == coupon.code;
                      return CouponTicketCard(
                        coupon: coupon,
                        accent: accents[index % accents.length],
                        actionLabel: applied
                            ? 'Applied'
                            : eligible
                            ? 'Apply coupon'
                            : 'Minimum not met',
                        actionIcon: applied ? AppIcons.check : AppIcons.offer,
                        onAction: eligible && !applied
                            ? () => _apply(coupon.code)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
