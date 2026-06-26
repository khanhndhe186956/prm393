import 'package:flutter/material.dart';

import '../../models/maintenance_request.dart';
import '../../services/request_service.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_button.dart';
import '../../widgets/status_chip_helper.dart';

class StaffRequestDetailScreen extends StatefulWidget {
  const StaffRequestDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  State<StaffRequestDetailScreen> createState() => _StaffRequestDetailScreenState();
}

class _StaffRequestDetailScreenState extends State<StaffRequestDetailScreen> {
  final _noteController = TextEditingController();
  final _requestService = RequestService();
  RequestStatus? _selectedStatus;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final request = _requestService.getById(widget.requestId);
    if (request == null || _selectedStatus == null) return;

    _requestService.updateStatus(
      id: widget.requestId,
      status: _selectedStatus!,
      resolutionNote: _noteController.text.trim().isEmpty
          ? request.resolutionNote
          : _noteController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request status updated.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final request = _requestService.getById(widget.requestId);
    if (request == null) {
      return const Scaffold(body: Center(child: Text('Request not found')));
    }

    _selectedStatus ??= request.status;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Request')),
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
          Text(request.description),
          const SizedBox(height: 8),
          Text(
            'Submitted: ${Formatters.dateTime(request.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<RequestStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Update status',
              border: OutlineInputBorder(),
            ),
            items: RequestStatus.values
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(MaintenanceRequest.statusLabel(status)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedStatus = value),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Resolution note (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          AppButton(label: 'Save Changes', onPressed: _save),
        ],
      ),
    );
  }
}
