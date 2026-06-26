import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/bill.dart';
import '../../models/maintenance_request.dart';
import '../../models/visitor.dart';
import '../../services/auth_service.dart';
import '../../services/bill_service.dart';
import '../../services/request_service.dart';
import '../../services/visitor_service.dart';
import '../../widgets/info_card.dart';
import 'create_bill_screen.dart';
import 'staff_bill_list_screen.dart';
import 'staff_request_detail_screen.dart';
import 'staff_request_list_screen.dart';
import 'visitor_list_screen.dart';

class StaffShell extends StatefulWidget {
  const StaffShell({super.key});

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _index = 0;

  void _refresh() => setState(() {});

  Future<void> _openCreateBill() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreateBillScreen()),
    );
    if (created == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser!;
    final requests = RequestService().getAll();
    final bills = BillService().getAll();
    final visitors = VisitorService().getAll();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          if (_index == 2)
            IconButton(icon: const Icon(Icons.add), onPressed: _openCreateBill),
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
          _StaffHomeTab(
            staffName: user.fullName,
            pendingRequests:
                requests.where((r) => r.status == RequestStatus.pending).length,
            unpaidBills: bills.where((b) => b.status == BillStatus.unpaid).length,
            activeVisitors: visitors
                .where((v) => v.status != VisitorStatus.checkedOut)
                .length,
            onOpenRequests: () => setState(() => _index = 1),
            onOpenBills: () => setState(() => _index = 2),
            onOpenVisitors: () => setState(() => _index = 3),
          ),
          StaffRequestListScreen(
            requests: requests,
            onTap: (id) async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StaffRequestDetailScreen(requestId: id),
                ),
              );
              _refresh();
            },
          ),
          StaffBillListScreen(bills: bills, onCreate: _openCreateBill),
          VisitorListScreen(visitors: visitors, onRefresh: _refresh),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Bills',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Visitors',
          ),
        ],
      ),
    );
  }

  static const _titles = ['Dashboard', 'Requests', 'Bills', 'Visitors'];
}

class _StaffHomeTab extends StatelessWidget {
  const _StaffHomeTab({
    required this.staffName,
    required this.pendingRequests,
    required this.unpaidBills,
    required this.activeVisitors,
    required this.onOpenRequests,
    required this.onOpenBills,
    required this.onOpenVisitors,
  });

  final String staffName;
  final int pendingRequests;
  final int unpaidBills;
  final int activeVisitors;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenBills;
  final VoidCallback onOpenVisitors;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Hello, $staffName', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Building operations overview'),
        const SizedBox(height: 24),
        InfoCard(
          title: 'Pending requests',
          value: '$pendingRequests',
          icon: Icons.pending_actions,
          onTap: onOpenRequests,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Unpaid bills',
          value: '$unpaidBills',
          icon: Icons.request_quote_outlined,
          onTap: onOpenBills,
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Active visitors',
          value: '$activeVisitors',
          icon: Icons.door_front_door_outlined,
          onTap: onOpenVisitors,
        ),
      ],
    );
  }
}
