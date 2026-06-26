class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String content;
  final String createdBy;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      content: content,
      createdBy: createdBy,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
