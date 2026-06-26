import '../models/apartment.dart';
import '../models/maintenance_request.dart';
import 'mock_data.dart';

class RequestService {
  List<MaintenanceRequest> getAll() =>
      List<MaintenanceRequest>.from(MockData.requests);

  List<MaintenanceRequest> getByResident(String residentId) {
    return getAll()
        .where((request) => request.residentId == residentId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  MaintenanceRequest? getById(String id) {
    try {
      return getAll().firstWhere((request) => request.id == id);
    } catch (_) {
      return null;
    }
  }

  MaintenanceRequest create({
    required String residentId,
    required String apartmentId,
    required String title,
    required String description,
    required RequestCategory category,
  }) {
    final request = MaintenanceRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      residentId: residentId,
      apartmentId: apartmentId,
      title: title,
      description: description,
      category: category,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );
    MockData.requests.insert(0, request);
    return request;
  }

  void updateStatus({
    required String id,
    required RequestStatus status,
    String? resolutionNote,
  }) {
    final index = MockData.requests.indexWhere((request) => request.id == id);
    if (index == -1) return;
    MockData.requests[index] = MockData.requests[index].copyWith(
      status: status,
      resolutionNote: resolutionNote,
    );
  }

  Apartment? getApartment(String apartmentId) {
    try {
      return MockData.apartments.firstWhere((apt) => apt.id == apartmentId);
    } catch (_) {
      return null;
    }
  }
}
