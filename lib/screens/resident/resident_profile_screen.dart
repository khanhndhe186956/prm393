import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/request_service.dart';
import '../../services/visitor_service.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ResidentProfileScreen extends StatelessWidget {
  const ResidentProfileScreen({
    super.key,
    required this.user,
    required this.onRegisterVisitor,
    required this.onLogout,
  });

  final AppUser user;
  final VoidCallback onRegisterVisitor;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final apartment = user.apartmentId != null
        ? RequestService().getApartment(user.apartmentId!)
        : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(height: 16),
        Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall),
        Text(user.email),
        const SizedBox(height: 24),
        _InfoTile(label: 'Phone', value: user.phone ?? '-'),
        _InfoTile(label: 'Apartment', value: apartment?.displayName ?? '-'),
        _InfoTile(label: 'National ID', value: user.nationalId ?? '-'),
        const SizedBox(height: 24),
        AppButton(
          label: 'Register Visitor',
          outlined: true,
          onPressed: onRegisterVisitor,
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Logout',
          outlined: true,
          onPressed: onLogout,
        ),
      ],
    );
  }
}

class RegisterVisitorScreen extends StatefulWidget {
  const RegisterVisitorScreen({super.key});

  @override
  State<RegisterVisitorScreen> createState() => _RegisterVisitorScreenState();
}

class _RegisterVisitorScreenState extends State<RegisterVisitorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime _visitTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: _visitTime,
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_visitTime),
    );
    if (time == null) return;

    setState(() {
      _visitTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthService>().currentUser!;
    if (user.apartmentId == null) return;

    VisitorService().register(
      residentId: user.id,
      apartmentId: user.apartmentId!,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      visitTime: _visitTime,
      purpose: _purposeController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visitor registered successfully.')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Visitor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Visitor name',
                  controller: _nameController,
                  validator: (v) => Validators.requiredField(v, 'Visitor name'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Phone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => Validators.requiredField(v, 'Phone'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Purpose of visit',
                  controller: _purposeController,
                  validator: (v) => Validators.requiredField(v, 'Purpose'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Visit time'),
                  subtitle: Text(_visitTime.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDateTime,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(label: 'Register', onPressed: _submit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
