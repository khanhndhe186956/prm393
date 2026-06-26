import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../models/maintenance_request.dart';
import '../models/visitor.dart';
import 'status_chip.dart';

class StatusChipHelper {
  static Widget request(RequestStatus status) {
    return StatusChip(
      label: MaintenanceRequest.statusLabel(status),
      color: _requestColor(status),
    );
  }

  static Widget bill(BillStatus status) {
    return StatusChip(
      label: Bill.statusLabel(status),
      color: status == BillStatus.paid ? Colors.green : Colors.orange,
    );
  }

  static Widget visitor(VisitorStatus status) {
    return StatusChip(
      label: Visitor.statusLabel(status),
      color: _visitorColor(status),
    );
  }

  static Color _requestColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.confirmed:
        return Colors.blue;
      case RequestStatus.inProgress:
        return Colors.indigo;
      case RequestStatus.completed:
        return Colors.green;
    }
  }

  static Color _visitorColor(VisitorStatus status) {
    switch (status) {
      case VisitorStatus.registered:
        return Colors.blue;
      case VisitorStatus.checkedIn:
        return Colors.green;
      case VisitorStatus.checkedOut:
        return Colors.grey;
    }
  }
}
