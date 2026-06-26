import '../models/apartment.dart';
import '../models/app_user.dart';
import 'mock_data.dart';

class ApartmentService {
  List<Apartment> getAll() => List<Apartment>.from(MockData.apartments);

  List<AppUser> getResidents() {
    return MockData.users.where((user) => user.apartmentId != null).toList();
  }

  List<AppUser> getAllUsers() => List<AppUser>.from(MockData.users);
}
