import '../models/bill.dart';
import 'mock_data.dart';

class BillService {
  List<Bill> getAll() => List<Bill>.from(MockData.bills);

  List<Bill> getByResident(String residentId) {
    return getAll().where((bill) => bill.residentId == residentId).toList()
      ..sort((a, b) => b.billingMonth.compareTo(a.billingMonth));
  }

  Bill? getById(String id) {
    try {
      return getAll().firstWhere((bill) => bill.id == id);
    } catch (_) {
      return null;
    }
  }

  Bill create({
    required String apartmentId,
    required String residentId,
    required BillType type,
    required double amount,
    required DateTime billingMonth,
    required DateTime dueDate,
  }) {
    final bill = Bill(
      id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
      apartmentId: apartmentId,
      residentId: residentId,
      type: type,
      amount: amount,
      billingMonth: billingMonth,
      dueDate: dueDate,
      status: BillStatus.unpaid,
    );
    MockData.bills.insert(0, bill);
    return bill;
  }

  void markAsPaid(String id) {
    final index = MockData.bills.indexWhere((bill) => bill.id == id);
    if (index == -1) return;
    MockData.bills[index] = MockData.bills[index].copyWith(
      status: BillStatus.paid,
    );
  }
}
