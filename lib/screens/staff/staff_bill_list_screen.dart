import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip_helper.dart';

class StaffBillListScreen extends StatelessWidget {
  const StaffBillListScreen({
    super.key,
    required this.bills,
    required this.onCreate,
  });

  final List<Bill> bills;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(label: 'Create Invoice', onPressed: onCreate),
        ),
        Expanded(
          child: bills.isEmpty
              ? const EmptyState(message: 'No bills created yet.')
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bills.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    return Card(
                      child: ListTile(
                        title: Text('${Bill.typeLabel(bill.type)} • Apt ${bill.apartmentId}'),
                        subtitle: Text(
                          '${Formatters.month(bill.billingMonth)} • ${Formatters.currency(bill.amount)}',
                        ),
                        trailing: StatusChipHelper.bill(bill.status),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
