import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip_helper.dart';

class BillListScreen extends StatelessWidget {
  const BillListScreen({
    super.key,
    required this.bills,
    required this.onTap,
  });

  final List<Bill> bills;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) {
      return const EmptyState(
        message: 'No bills available.',
        icon: Icons.receipt_long_outlined,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final bill = bills[index];
        return Card(
          child: ListTile(
            title: Text(Bill.typeLabel(bill.type)),
            subtitle: Text(
              '${Formatters.month(bill.billingMonth)} • Due ${Formatters.date(bill.dueDate)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currency(bill.amount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                StatusChipHelper.bill(bill.status),
              ],
            ),
            onTap: () => onTap(bill.id),
          ),
        );
      },
    );
  }
}
