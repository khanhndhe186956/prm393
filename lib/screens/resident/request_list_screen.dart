import 'package:flutter/material.dart';

import '../../models/maintenance_request.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip_helper.dart';

class RequestListScreen extends StatelessWidget {
  const RequestListScreen({
    super.key,
    required this.requests,
    required this.onTap,
    required this.onCreate,
  });

  final List<MaintenanceRequest> requests;
  final ValueChanged<String> onTap;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return EmptyState(
        message: 'No maintenance requests yet.',
        icon: Icons.build_outlined,
      );
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
              '${MaintenanceRequest.categoryLabel(request.category)} • ${Formatters.dateTime(request.createdAt)}',
            ),
            trailing: StatusChipHelper.request(request.status),
            onTap: () => onTap(request.id),
          ),
        );
      },
    );
  }
}
