import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/apartment_service.dart';
import '../../services/auth_service.dart';
import '../../services/bill_service.dart';
import '../../services/notification_service.dart';
import '../../services/request_service.dart';
import '../../utils/constants.dart';
import '../../widgets/info_card.dart';
import 'apartment_list_screen.dart';
import 'announcement_list_screen.dart';
import 'user_list_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser!;
    final apartments = ApartmentService().getAll();
    final users = ApartmentService().getAllUsers();
    final requests = RequestService().getAll();
    final bills = BillService().getAll();
    final notifications = NotificationService().getAll();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthService>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          _AdminHomeTab(
            adminName: user.fullName,
            apartmentCount: apartments.length,
            userCount: users.length,
            requestCount: requests.length,
            billCount: bills.length,
            onOpenApartments: () => setState(() => _index = 1),
            onOpenUsers: () => setState(() => _index = 2),
            onOpenAnnouncements: () => setState(() => _index = 3),
          ),
          ApartmentListScreen(apartments: apartments),
          UserListScreen(users: users),
          AnnouncementListScreen(notifications: notifications),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.apartment_outlined),
            selectedIcon: Icon(Icons.apartment),
            label: 'Apartments',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Announcements',
          ),
        ],
      ),
    );
  }

  static const _titles = ['Admin', 'Apartments', 'Users', 'Announcements'];
}

class _AdminHomeTab extends StatelessWidget {
  const _AdminHomeTab({
    required this.adminName,
    required this.apartmentCount,
    required this.userCount,
    required this.requestCount,
    required this.billCount,
    required this.onOpenApartments,
    required this.onOpenUsers,
    required this.onOpenAnnouncements,
  });

  final String adminName;
  final int apartmentCount;
  final int userCount;
  final int requestCount;
  final int billCount;
  final VoidCallback onOpenApartments;
  final VoidCallback onOpenUsers;
  final VoidCallback onOpenAnnouncements;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Admin Dashboard', style: Theme.of(context).textTheme.headlineSmall),
        Text('Hello, $adminName'),
        const SizedBox(height: 8),
        Text('${AppConstants.buildingName} • ${AppConstants.totalFloors} floors'),
        const SizedBox(height: 24),
        InfoCard(
          title: 'Apartments',
          value: '$apartmentCount units',
          icon: Icons.apartment,
          onTap: onOpenApartments,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Users',
          value: '$userCount accounts',
          icon: Icons.people,
          onTap: onOpenUsers,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Open requests',
          value: '$requestCount',
          icon: Icons.build,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Bills',
          value: '$billCount',
          icon: Icons.receipt,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Announcements',
          value: 'Manage building notices',
          icon: Icons.campaign_outlined,
          onTap: onOpenAnnouncements,
        ),
      ],
    );
  }
}
