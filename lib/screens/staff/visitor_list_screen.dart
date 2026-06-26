import 'package:flutter/material.dart';

import '../../models/visitor.dart';
import '../../services/visitor_service.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip_helper.dart';

class VisitorListScreen extends StatelessWidget {
  const VisitorListScreen({
    super.key,
    required this.visitors,
    required this.onRefresh,
  });

  final List<Visitor> visitors;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (visitors.isEmpty) {
      return const EmptyState(message: 'No registered visitors.');
    }

    final service = VisitorService();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: visitors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final visitor = visitors[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        visitor.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusChipHelper.visitor(visitor.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Apt ${visitor.apartmentId} • ${visitor.phone}'),
                Text('Visit: ${Formatters.dateTime(visitor.visitTime)}'),
                Text('Purpose: ${visitor.purpose}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (visitor.status == VisitorStatus.registered)
                      Expanded(
                        child: AppButton(
                          label: 'Check In',
                          onPressed: () {
                            service.updateStatus(
                              visitor.id,
                              VisitorStatus.checkedIn,
                            );
                            onRefresh();
                          },
                        ),
                      ),
                    if (visitor.status == VisitorStatus.checkedIn) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          label: 'Check Out',
                          onPressed: () {
                            service.updateStatus(
                              visitor.id,
                              VisitorStatus.checkedOut,
                            );
                            onRefresh();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
