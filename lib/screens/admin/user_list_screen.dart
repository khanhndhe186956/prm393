import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../widgets/empty_state.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key, required this.users});

  final List<AppUser> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const EmptyState(message: 'No users found.');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(user.fullName[0])),
            title: Text(user.fullName),
            subtitle: Text('${user.role.label} • ${user.email}'),
            trailing: Chip(label: Text(user.status.name)),
          ),
        );
      },
    );
  }
}
