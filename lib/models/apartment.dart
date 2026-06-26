class Apartment {
  const Apartment({
    required this.id,
    required this.number,
    required this.floor,
    required this.building,
    this.ownerId,
  });

  final String id;
  final String number;
  final int floor;
  final String building;
  final String? ownerId;

  String get displayName => '$building - Floor $floor - Apt $number';
}
