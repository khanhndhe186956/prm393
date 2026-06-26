enum VisitorStatus { registered, checkedIn, checkedOut }

class Visitor {
  const Visitor({
    required this.id,
    required this.residentId,
    required this.apartmentId,
    required this.name,
    required this.phone,
    required this.visitTime,
    required this.purpose,
    required this.status,
  });

  final String id;
  final String residentId;
  final String apartmentId;
  final String name;
  final String phone;
  final DateTime visitTime;
  final String purpose;
  final VisitorStatus status;

  Visitor copyWith({VisitorStatus? status}) {
    return Visitor(
      id: id,
      residentId: residentId,
      apartmentId: apartmentId,
      name: name,
      phone: phone,
      visitTime: visitTime,
      purpose: purpose,
      status: status ?? this.status,
    );
  }

  static String statusLabel(VisitorStatus status) {
    switch (status) {
      case VisitorStatus.registered:
        return 'Registered';
      case VisitorStatus.checkedIn:
        return 'Checked In';
      case VisitorStatus.checkedOut:
        return 'Checked Out';
    }
  }
}
