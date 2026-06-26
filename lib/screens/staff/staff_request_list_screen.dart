import 'package:flutter/material.dart';

import '../../models/maintenance_request.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip_helper.dart';

class StaffRequestListScreen extends StatelessWidget {
  const StaffRequestListScreen({
    super.key,
    required this.requests,
    required this.onTap,
  });

  final List<MaintenanceRequest> requests;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const EmptyState(message: 'No maintenance requests.');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          child: ListTile(
            title: Text(request.title),
            subtitle: Text(
              'Apt ${request.apartmentId} • ${Formatters.dateTime(request.createdAt)}',
            ),
            trailing: StatusChipHelper.request(request.status),
            onTap: () => onTap(request.id),
          ),
        );
      },
    );
  }
}
