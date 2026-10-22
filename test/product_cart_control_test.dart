import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scannerapp/feature/product/presentation/widgets/product_cart_control.dart';

Widget _control(ValueNotifier<int> quantity, {int stock = 120}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: ValueListenableBuilder<int>(
        valueListenable: quantity,
        builder: (context, value, child) => ProductCartControl(
          compact: true,
          quantity: value,
          stock: stock,
          onAdd: () => quantity.value++,
          onIncrease: () => quantity.value++,
          onDecrease: () => quantity.value--,
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('counter collapses after inactivity and reopens without adding', (
    tester,
  ) async {
    final quantity = ValueNotifier(0);
    addTearDown(quantity.dispose);
    await tester.pumpWidget(_control(quantity));
    await tester.tap(find.byTooltip('Add to cart'));
    await tester.pump();
    expect(quantity.value, 1);
    expect(find.byTooltip('Increase quantity'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2500));
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    expect(quantity.value, 2);
    await tester.pump(const Duration(milliseconds: 2500));
    expect(find.byTooltip('Increase quantity'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Increase quantity'), findsNothing);
    expect(find.byTooltip('Decrease quantity'), findsNothing);
    expect(find.byTooltip('Change quantity'), findsOneWidget);
    expect(tester.getSize(find.byType(ProductCartControl)), const Size(28, 28));

    await tester.tap(find.byTooltip('Change quantity'));
    await tester.pumpAndSettle();
    expect(quantity.value, 2);
    expect(find.byTooltip('Increase quantity'), findsOneWidget);
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pump();
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(quantity.value, 0);
    expect(find.byTooltip('Add to cart'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'existing quantities start collapsed and stock limits still apply',
    (tester) async {
      final quantity = ValueNotifier(2);
      addTearDown(quantity.dispose);
      await tester.pumpWidget(_control(quantity, stock: 2));
      expect(find.byTooltip('Change quantity'), findsOneWidget);
      await tester.tap(find.byTooltip('Change quantity'));
      await tester.pumpAndSettle();
      final increase = tester.widget<IconButton>(
        find.byWidgetPredicate(
          (widget) =>
              widget is IconButton && widget.tooltip == 'Increase quantity',
        ),
      );
      expect(increase.onPressed, isNull);
      await tester.tap(find.byTooltip('Decrease quantity'));
      await tester.pump();
      expect(quantity.value, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    },
  );
}
