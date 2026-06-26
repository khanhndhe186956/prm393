import '../models/apartment.dart';
import '../models/app_user.dart';
import '../models/bill.dart';
import '../models/maintenance_request.dart';
import '../models/notification_item.dart';
import '../models/user_role.dart';
import '../models/visitor.dart';
import '../utils/app_messages.dart';
import '../utils/constants.dart';

class MockData {
  MockData._();

  static const residentId = 'user_resident_01';
  static const staffId = 'user_staff_01';
  static const adminId = 'user_admin_01';
  static const apartmentId = 'apt_1201';

  static final users = <AppUser>[
    const AppUser(
      id: residentId,
      email: AppConstants.residentEmail,
      fullName: 'Nguyen Van A',
      role: UserRole.resident,
      phone: '0901234567',
      apartmentId: apartmentId,
      nationalId: '001234567890',
      dateOfBirth: null,
    ),
    const AppUser(
      id: staffId,
      email: AppConstants.staffEmail,
      fullName: 'Tran Thi B',
      role: UserRole.staff,
      phone: '0912345678',
    ),
    const AppUser(
      id: adminId,
      email: AppConstants.adminEmail,
      fullName: 'Le Van C',
      role: UserRole.admin,
      phone: '0923456789',
    ),
    const AppUser(
      id: 'user_resident_02',
      email: 'resident2@demo.com',
      fullName: 'Pham Van D',
      role: UserRole.resident,
      phone: '0934567890',
      apartmentId: 'apt_1102',
    ),
  ];

  static final apartments = <Apartment>[
    const Apartment(
      id: apartmentId,
      number: '1201',
      floor: 12,
      building: AppConstants.buildingName,
      ownerId: residentId,
    ),
    const Apartment(
      id: 'apt_1102',
      number: '1102',
      floor: 11,
      building: AppConstants.buildingName,
      ownerId: 'user_resident_02',
    ),
    const Apartment(
      id: 'apt_0803',
      number: '0803',
      floor: 8,
      building: AppConstants.buildingName,
    ),
  ];

  static final requests = <MaintenanceRequest>[
    MaintenanceRequest(
      id: 'req_01',
      residentId: residentId,
      apartmentId: apartmentId,
      title: 'Leaking kitchen pipe',
      description: 'Water leaking under the kitchen sink since yesterday.',
      category: RequestCategory.plumbing,
      status: RequestStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MaintenanceRequest(
      id: 'req_02',
      residentId: residentId,
      apartmentId: apartmentId,
      title: 'Living room light flickering',
      description: 'Ceiling light flickers when turned on.',
      category: RequestCategory.electrical,
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    MaintenanceRequest(
      id: 'req_03',
      residentId: 'user_resident_02',
      apartmentId: 'apt_1102',
      title: 'Broken door lock',
      description: 'Main door lock is stuck and hard to turn.',
      category: RequestCategory.general,
      status: RequestStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      resolutionNote: 'Lock replaced on 19/06/2026.',
    ),
  ];

  static final bills = <Bill>[
    Bill(
      id: 'bill_01',
      apartmentId: apartmentId,
      residentId: residentId,
      type: BillType.service,
      amount: 1500000,
      billingMonth: DateTime(2026, 6),
      dueDate: DateTime(2026, 6, 15),
      status: BillStatus.unpaid,
    ),
    Bill(
      id: 'bill_02',
      apartmentId: apartmentId,
      residentId: residentId,
      type: BillType.electricity,
      amount: 850000,
      billingMonth: DateTime(2026, 5),
      dueDate: DateTime(2026, 5, 15),
      status: BillStatus.paid,
    ),
    Bill(
      id: 'bill_03',
      apartmentId: 'apt_1102',
      residentId: 'user_resident_02',
      type: BillType.water,
      amount: 320000,
      billingMonth: DateTime(2026, 6),
      dueDate: DateTime(2026, 6, 15),
      status: BillStatus.unpaid,
    ),
  ];

  static final notifications = <NotificationItem>[
    NotificationItem(
      id: 'noti_01',
      title: 'Elevator maintenance',
      content: 'Elevator B will be under maintenance on 28/06 from 8:00 to 12:00.',
      createdBy: adminId,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      id: 'noti_02',
      title: 'June service fee reminder',
      content: AppMessages.billNotification('06/2026', '1,500,000₫'),
      createdBy: staffId,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  static final visitors = <Visitor>[
    Visitor(
      id: 'vis_01',
      residentId: residentId,
      apartmentId: apartmentId,
      name: 'Hoang Minh',
      phone: '0987654321',
      visitTime: DateTime.now().add(const Duration(hours: 2)),
      purpose: 'Family visit',
      status: VisitorStatus.registered,
    ),
    Visitor(
      id: 'vis_02',
      residentId: 'user_resident_02',
      apartmentId: 'apt_1102',
      name: 'Nguyen Lan',
      phone: '0976543210',
      visitTime: DateTime.now().subtract(const Duration(hours: 1)),
      purpose: 'Delivery',
      status: VisitorStatus.checkedIn,
    ),
  ];
}
