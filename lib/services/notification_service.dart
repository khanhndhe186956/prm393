import '../models/notification_item.dart';
import 'mock_data.dart';

class NotificationService {
  List<NotificationItem> getAll() =>
      List<NotificationItem>.from(MockData.notifications)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void markAsRead(String id) {
    final index = MockData.notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    MockData.notifications[index] =
        MockData.notifications[index].copyWith(isRead: true);
  }
}
