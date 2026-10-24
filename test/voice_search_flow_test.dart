import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/core/providers/shop_provider.dart';
import 'package:scannerapp/feature/search/data/services/voice_search_service.dart';
import 'package:scannerapp/feature/search/presentation/screens/search_screen.dart';
import 'package:scannerapp/feature/search/presentation/widgets/product_result_card.dart';

class _FakeVoiceSearchService implements VoiceSearchService {
  ValueChanged<String>? _onResult;
  ValueChanged<bool>? _onListeningChanged;
  int starts = 0;
  int stops = 0;
  int cancels = 0;
  bool _isListening = false;

  @override
  bool get isListening => _isListening;

  @override
  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<bool> onListeningChanged,
  }) async {
    _onListeningChanged = onListeningChanged;
    return true;
  }

  @override
  Future<void> start({required ValueChanged<String> onResult}) async {
    starts++;
    _onResult = onResult;
    _isListening = true;
    _onListeningChanged?.call(true);
  }

  void recognize(String words) => _onResult?.call(words);

  @override
  Future<void> stop() async {
    stops++;
    _isListening = false;
    _onListeningChanged?.call(false);
  }

  @override
  Future<void> cancel() async {
    cancels++;
    _isListening = false;
  }
}

void main() {
  testWidgets(
    'voice input fills the search field and filters catalog results',
    (tester) async {
      final voice = _FakeVoiceSearchService();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ShopProvider(),
          child: MaterialApp(
            home: SearchScreen(
              voiceSearchService: voice,
              startVoiceSearchOnOpen: true,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(voice.starts, 1);
      expect(find.byTooltip('Stop voice search'), findsOneWidget);

      voice.recognize('Relivo');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        'Relivo',
      );
      expect(find.byType(ProductResultCard), findsOneWidget);

      await tester.tap(find.byTooltip('Stop voice search'));
      await tester.pump();
      expect(voice.stops, 1);
      await tester.tap(find.byTooltip('Search by voice'));
      await tester.pump();
      expect(voice.starts, 2);

      await tester.enterText(find.byType(TextField), 'VitaGlow');
      await tester.pump();
      expect(voice.cancels, 1);
      voice.recognize('Relivo');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        'VitaGlow',
      );
    },
  );
}
