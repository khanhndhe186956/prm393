import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../services/apartment_service.dart';
import '../../services/bill_service.dart';
import '../../services/mock_data.dart';
import '../../utils/app_messages.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _apartmentService = ApartmentService();
  final _billService = BillService();

  String? _apartmentId = MockData.apartmentId;
  BillType _billType = BillType.service;
  DateTime _billingMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _dueDate = DateTime.now().add(const Duration(days: 15));

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickBillingMonth() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      initialDate: _billingMonth,
    );
    if (date != null) {
      setState(() => _billingMonth = DateTime(date.year, date.month));
    }
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _dueDate,
    );
    if (date != null) setState(() => _dueDate = date);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_apartmentId == null) return;

    final apartment = _apartmentService.getAll().firstWhere(
          (a) => a.id == _apartmentId,
        );
    final residentId = apartment.ownerId ?? MockData.residentId;

    _billService.create(
      apartmentId: _apartmentId!,
      residentId: residentId,
      type: _billType,
      amount: double.parse(_amountController.text.trim()),
      billingMonth: _billingMonth,
      dueDate: _dueDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppMessages.billNotification(
            '${_billingMonth.month}/${_billingMonth.year}',
            _amountController.text,
          ),
        ),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final apartments = _apartmentService.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _apartmentId,
                  decoration: const InputDecoration(
                    labelText: 'Apartment',
                    border: OutlineInputBorder(),
                  ),
                  items: apartments
                      .map(
                        (apt) => DropdownMenuItem(
                          value: apt.id,
                          child: Text(apt.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _apartmentId = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BillType>(
                  value: _billType,
                  decoration: const InputDecoration(
                    labelText: 'Bill type',
                    border: OutlineInputBorder(),
                  ),
                  items: BillType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(Bill.typeLabel(type)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _billType = value);
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Amount',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: Validators.amount,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Billing month'),
                  subtitle: Text('${_billingMonth.month}/${_billingMonth.year}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickBillingMonth,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Due date'),
                  subtitle: Text(_dueDate.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.event),
                    onPressed: _pickDueDate,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Generate Bill', onPressed: _submit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
