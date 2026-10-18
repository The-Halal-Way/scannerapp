import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';

class OrderProgressTracker extends StatelessWidget {
  const OrderProgressTracker({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final reached = switch (status) {
      OrderStatus.placed => 0,
      OrderStatus.onTheWay => 1,
      OrderStatus.delivered => 2,
    };
    const labels = ['Placed', 'On the way', 'Delivered'];
    const icons = [AppIcons.receipt, AppIcons.delivery, AppIcons.home];

    return Row(
      children: List.generate(labels.length, (index) {
        final active = index <= reached;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: active ? colors.brand : colors.stroke,
                      ),
                    ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: active ? colors.brand : colors.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icons[index],
                      size: 17,
                      color: active ? Colors.white : colors.textMuted,
                    ),
                  ),
                  if (index < 2)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < reached ? colors.brand : colors.stroke,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: active ? colors.brand : colors.textMuted,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
