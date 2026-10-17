import 'package:flutter/foundation.dart';
import 'package:scannerapp/feature/inbox/data/demo_inbox_repository.dart';
import 'package:scannerapp/feature/inbox/data/models/inbox_message.dart';

enum InboxFilter { all, orders, offers }

class InboxProvider extends ChangeNotifier {
  final List<InboxMessage> _messages = List.of(DemoInboxRepository.messages);
  InboxFilter _filter = InboxFilter.all;

  InboxFilter get filter => _filter;
  int get unreadCount => _messages.where((message) => !message.isRead).length;

  List<InboxMessage> get visibleMessages => List.unmodifiable(
    _messages.where(
      (message) => switch (_filter) {
        InboxFilter.all => true,
        InboxFilter.orders => message.category == InboxCategory.orders,
        InboxFilter.offers => message.category == InboxCategory.offers,
      },
    ),
  );

  void setFilter(InboxFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  void markRead(String id) {
    final index = _messages.indexWhere((message) => message.id == id);
    if (index < 0 || _messages[index].isRead) return;
    _messages[index] = _messages[index].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllRead() {
    if (unreadCount == 0) return;
    for (var index = 0; index < _messages.length; index++) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }
    notifyListeners();
  }
}
