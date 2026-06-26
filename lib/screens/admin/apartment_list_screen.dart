import 'package:flutter/material.dart';

import '../../models/apartment.dart';
import '../../services/apartment_service.dart';
import '../../widgets/empty_state.dart';

class ApartmentListScreen extends StatelessWidget {
  const ApartmentListScreen({super.key, required this.apartments});

  final List<Apartment> apartments;

  @override
  Widget build(BuildContext context) {
    if (apartments.isEmpty) {
      return const EmptyState(message: 'No apartments found.');
    }

    final userService = ApartmentService();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: apartments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final apartment = apartments[index];
        final owner = apartment.ownerId != null
            ? userService
                .getAllUsers()
                .where((u) => u.id == apartment.ownerId)
                .firstOrNull
            : null;

        return Card(
          child: ListTile(
            leading: const Icon(Icons.home_work_outlined),
            title: Text(apartment.displayName),
            subtitle: Text('Owner: ${owner?.fullName ?? 'Unassigned'}'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
