enum InboxCategory { orders, offers, updates }

class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.timeLabel,
    this.isRead = false,
  });

  final String id;
  final InboxCategory category;
  final String title;
  final String body;
  final String timeLabel;
  final bool isRead;

  InboxMessage copyWith({bool? isRead}) => InboxMessage(
    id: id,
    category: category,
    title: title,
    body: body,
    timeLabel: timeLabel,
    isRead: isRead ?? this.isRead,
  );
}
