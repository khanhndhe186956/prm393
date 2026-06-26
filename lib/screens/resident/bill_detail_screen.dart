import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../services/bill_service.dart';
import '../../utils/app_messages.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_button.dart';
import '../../widgets/status_chip_helper.dart';

class BillDetailScreen extends StatefulWidget {
  const BillDetailScreen({super.key, required this.billId});

  final String billId;

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  final _billService = BillService();

  void _pay() {
    _billService.markAsPaid(widget.billId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppMessages.paymentSuccess)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bill = _billService.getById(widget.billId);
    if (bill == null) {
      return const Scaffold(body: Center(child: Text('Bill not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bill Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Bill.typeLabel(bill.type),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              StatusChipHelper.bill(bill.status),
            ],
          ),
          const SizedBox(height: 24),
          _DetailRow(label: 'Billing month', value: Formatters.month(bill.billingMonth)),
          _DetailRow(label: 'Due date', value: Formatters.date(bill.dueDate)),
          _DetailRow(label: 'Amount', value: Formatters.currency(bill.amount)),
          const SizedBox(height: 24),
          if (bill.status == BillStatus.unpaid)
            AppButton(label: 'Pay Now (Mock)', onPressed: _pay),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
