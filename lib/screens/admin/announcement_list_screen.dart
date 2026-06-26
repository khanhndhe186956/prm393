import 'package:flutter/material.dart';

import '../../models/notification_item.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';

class AnnouncementListScreen extends StatelessWidget {
  const AnnouncementListScreen({super.key, required this.notifications});

  final List<NotificationItem> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const EmptyState(
        message: 'No announcements yet.',
        icon: Icons.campaign_outlined,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(item.content),
                const SizedBox(height: 8),
                Text(
                  Formatters.dateTime(item.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
