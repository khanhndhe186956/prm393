enum BillType { electricity, water, service }

enum BillStatus { unpaid, paid }

class Bill {
  const Bill({
    required this.id,
    required this.apartmentId,
    required this.residentId,
    required this.type,
    required this.amount,
    required this.billingMonth,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final String apartmentId;
  final String residentId;
  final BillType type;
  final double amount;
  final DateTime billingMonth;
  final DateTime dueDate;
  final BillStatus status;

  Bill copyWith({BillStatus? status}) {
    return Bill(
      id: id,
      apartmentId: apartmentId,
      residentId: residentId,
      type: type,
      amount: amount,
      billingMonth: billingMonth,
      dueDate: dueDate,
      status: status ?? this.status,
    );
  }

  static String typeLabel(BillType type) {
    switch (type) {
      case BillType.electricity:
        return 'Electricity';
      case BillType.water:
        return 'Water';
      case BillType.service:
        return 'Service Fee';
    }
  }

  static String statusLabel(BillStatus status) {
    switch (status) {
      case BillStatus.unpaid:
        return 'Unpaid';
      case BillStatus.paid:
        return 'Paid';
    }
  }
}
