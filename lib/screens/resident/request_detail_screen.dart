import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/maintenance_request.dart';
import '../../services/auth_service.dart';
import '../../services/request_service.dart';
import '../../utils/app_messages.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/status_chip_helper.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final request = RequestService().getById(requestId);
    if (request == null) {
      return const Scaffold(body: Center(child: Text('Request not found')));
    }

    final apartment = RequestService().getApartment(request.apartmentId);

    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              StatusChipHelper.request(request.status),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow(
            label: 'Category',
            value: MaintenanceRequest.categoryLabel(request.category),
          ),
          _DetailRow(
            label: 'Apartment',
            value: apartment?.displayName ?? request.apartmentId,
          ),
          _DetailRow(
            label: 'Submitted',
            value: Formatters.dateTime(request.createdAt),
          ),
          const SizedBox(height: 12),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(request.description),
          if (request.resolutionNote != null) ...[
            const SizedBox(height: 16),
            Text('Resolution', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(request.resolutionNote!),
          ],
        ],
      ),
    );
  }
}

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  RequestCategory _category = RequestCategory.general;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthService>().currentUser!;
    if (user.apartmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No apartment assigned to this account.')),
      );
      return;
    }

    RequestService().create(
      residentId: user.id,
      apartmentId: user.apartmentId!,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppMessages.requestCreated)),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Request')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Title',
                  controller: _titleController,
                  validator: (v) => Validators.requiredField(v, 'Title'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 4,
                  validator: (v) => Validators.requiredField(v, 'Description'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<RequestCategory>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: RequestCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(MaintenanceRequest.categoryLabel(c)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Submit Request', onPressed: _submit),
              ],
            ),
          ),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
