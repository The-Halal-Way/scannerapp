import 'models/inbox_message.dart';

abstract final class DemoInboxRepository {
  static const messages = <InboxMessage>[
    InboxMessage(
      id: 'order-dispatched',
      category: InboxCategory.orders,
      title: 'Your order is on its way',
      body:
          'Order #MC-2408 has left the warehouse. Your medicines are expected tomorrow between 10 AM and 2 PM.',
      timeLabel: 'Today · 9:42 AM',
    ),
    InboxMessage(
      id: 'weekend-offer',
      category: InboxCategory.offers,
      title: 'A little extra for your shelves',
      body:
          'Save up to 18% on everyday essentials from trusted suppliers. Explore the weekend collection while stocks last.',
      timeLabel: 'Today · 8:15 AM',
    ),
    InboxMessage(
      id: 'invoice-ready',
      category: InboxCategory.orders,
      title: 'Invoice ready to view',
      body:
          'The invoice for order #MC-2407 is ready. Find your order summary and item details in the Orders tab.',
      timeLabel: 'Yesterday · 4:20 PM',
    ),
    InboxMessage(
      id: 'restock',
      category: InboxCategory.updates,
      title: 'Your favorites are back',
      body:
          'Several frequently ordered wellness and first aid products are available again. Take a look before they sell out.',
      timeLabel: 'Yesterday · 11:06 AM',
      isRead: true,
    ),
    InboxMessage(
      id: 'welcome',
      category: InboxCategory.updates,
      title: 'Welcome to Med Club',
      body:
          'Your pharmacy dashboard is ready. Browse wholesale products, build your cart, and keep every order in one place.',
      timeLabel: 'Monday · 10:30 AM',
      isRead: true,
    ),
  ];
}
