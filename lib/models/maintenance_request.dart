enum RequestCategory { plumbing, electrical, general }

enum RequestStatus { pending, confirmed, inProgress, completed }

class MaintenanceRequest {
  const MaintenanceRequest({
    required this.id,
    required this.residentId,
    required this.apartmentId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.imageUrl,
    this.resolutionNote,
  });

  final String id;
  final String residentId;
  final String apartmentId;
  final String title;
  final String description;
  final RequestCategory category;
  final RequestStatus status;
  final DateTime createdAt;
  final String? imageUrl;
  final String? resolutionNote;

  MaintenanceRequest copyWith({
    RequestStatus? status,
    String? resolutionNote,
  }) {
    return MaintenanceRequest(
      id: id,
      residentId: residentId,
      apartmentId: apartmentId,
      title: title,
      description: description,
      category: category,
      status: status ?? this.status,
      createdAt: createdAt,
      imageUrl: imageUrl,
      resolutionNote: resolutionNote ?? this.resolutionNote,
    );
  }

  static String categoryLabel(RequestCategory category) {
    switch (category) {
      case RequestCategory.plumbing:
        return 'Plumbing';
      case RequestCategory.electrical:
        return 'Electrical';
      case RequestCategory.general:
        return 'General';
    }
  }

  static String statusLabel(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.confirmed:
        return 'Confirmed';
      case RequestStatus.inProgress:
        return 'In Progress';
      case RequestStatus.completed:
        return 'Completed';
    }
  }
}
