import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/bill.dart';
import '../../models/maintenance_request.dart';
import '../../services/auth_service.dart';
import '../../services/bill_service.dart';
import '../../services/notification_service.dart';
import '../../services/request_service.dart';
import '../../widgets/info_card.dart';
import 'bill_detail_screen.dart';
import 'bill_list_screen.dart';
import 'request_detail_screen.dart';
import 'request_list_screen.dart';
import 'resident_profile_screen.dart';
import 'notification_list_screen.dart';

class ResidentShell extends StatefulWidget {
  const ResidentShell({super.key});

  @override
  State<ResidentShell> createState() => _ResidentShellState();
}

class _ResidentShellState extends State<ResidentShell> {
  int _index = 0;

  void _refresh() => setState(() {});

  Future<void> _openCreateRequest() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreateRequestScreen()),
    );
    if (created == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser!;
    final requests = RequestService().getByResident(user.id);
    final bills = BillService().getByResident(user.id);
    final notifications = NotificationService().getAll();
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          if (_index == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _openCreateRequest,
            ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          _ResidentHomeTab(
            userName: user.fullName,
            pendingRequests:
                requests.where((r) => r.status != RequestStatus.completed).length,
            unpaidBills: bills.where((b) => b.status == BillStatus.unpaid).length,
            onOpenRequests: () => setState(() => _index = 1),
            onOpenBills: () => setState(() => _index = 2),
            onOpenNotifications: () => setState(() => _index = 3),
          ),
          RequestListScreen(
            requests: requests,
            onCreate: _openCreateRequest,
            onTap: (id) async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RequestDetailScreen(requestId: id),
                ),
              );
              _refresh();
            },
          ),
          BillListScreen(
            bills: bills,
            onTap: (id) async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => BillDetailScreen(billId: id)),
              );
              _refresh();
            },
          ),
          NotificationListScreen(
            notifications: notifications,
            onRefresh: _refresh,
          ),
          ResidentProfileScreen(
            user: user,
            onRegisterVisitor: () async {
              final created = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const RegisterVisitorScreen()),
              );
              if (created == true) _refresh();
            },
            onLogout: () {
              context.read<AuthService>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Requests',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Bills',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: 'Alerts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static const _titles = ['Home', 'Requests', 'Bills', 'Notifications', 'Profile'];
}

class _ResidentHomeTab extends StatelessWidget {
  const _ResidentHomeTab({
    required this.userName,
    required this.pendingRequests,
    required this.unpaidBills,
    required this.onOpenRequests,
    required this.onOpenBills,
    required this.onOpenNotifications,
  });

  final String userName;
  final int pendingRequests;
  final int unpaidBills;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenBills;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Welcome, $userName',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your apartment services in one place.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        InfoCard(
          title: 'Active requests',
          value: '$pendingRequests',
          icon: Icons.build_circle_outlined,
          onTap: onOpenRequests,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Unpaid bills',
          value: '$unpaidBills',
          icon: Icons.payments_outlined,
          onTap: onOpenBills,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Announcements',
          value: 'View building updates',
          icon: Icons.campaign_outlined,
          onTap: onOpenNotifications,
        ),
      ],
    );
  }
}
