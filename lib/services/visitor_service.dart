import '../models/visitor.dart';
import 'mock_data.dart';

class VisitorService {
  List<Visitor> getAll() => List<Visitor>.from(MockData.visitors);

  List<Visitor> getByResident(String residentId) {
    return getAll()
        .where((visitor) => visitor.residentId == residentId)
        .toList();
  }

  Visitor register({
    required String residentId,
    required String apartmentId,
    required String name,
    required String phone,
    required DateTime visitTime,
    required String purpose,
  }) {
    final visitor = Visitor(
      id: 'vis_${DateTime.now().millisecondsSinceEpoch}',
      residentId: residentId,
      apartmentId: apartmentId,
      name: name,
      phone: phone,
      visitTime: visitTime,
      purpose: purpose,
      status: VisitorStatus.registered,
    );
    MockData.visitors.insert(0, visitor);
    return visitor;
  }

  void updateStatus(String id, VisitorStatus status) {
    final index = MockData.visitors.indexWhere((v) => v.id == id);
    if (index == -1) return;
    MockData.visitors[index] = MockData.visitors[index].copyWith(status: status);
  }
}
